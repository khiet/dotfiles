# Sweep untagged Desktop and Downloads items into ~/Desktop/Archives, bucket past months into MM-YY folders, gather screenshots, zip folders older than 2 months.
archive () {
	local dry_run=0
	local dest="$HOME/Desktop/Archives"

	# Parse flags
	while [[ "$1" == -* ]]; do
		case "$1" in
			--dry-run|-n) dry_run=1; shift ;;
			--dest)
				[ -z "$2" ] && { echo "--dest needs a directory"; return 1; }
				dest="$2"; shift 2 ;;
			--help|-h)
				echo "Usage: archive [--dry-run|-n] [--dest <dir>] [source_dir ...]"
				echo ""
				echo "Arguments:"
				echo "  source_dir   Folders to sweep (default: ~/Desktop and ~/Downloads)"
				echo ""
				echo "Flags:"
				echo "  --dry-run    Print what would move without moving anything"
				echo "  --dest       Archives folder (default: ~/Desktop/Archives)"
				echo ""
				echo "Step 1: every untagged, non-hidden item in each source moves to the Archives folder."
				echo "        Items carrying any Finder color tag stay put. In-progress browser"
				echo "        downloads (*.crdownload, *.download, *.part, *.partial) stay put."
				echo "Step 2: every non-hidden item at the top level of Archives created in a past month"
				echo "        moves into a MM-YY folder (e.g. 09-26 for September 2026). Items created"
				echo "        this month stay flat in Archives; a folder for this month is emptied back out."
				echo "Step 3: in Archives and in each MM-YY folder, files named Screenshot*.png move into a"
				echo "        screenshot subfolder, created on demand."
				echo "Step 4: every MM-YY folder older than 2 calendar months is zipped in place as MM-YY.zip"
				echo "        and the folder is removed once the zip passes an integrity test."
				echo "Nothing is ever overwritten; name collisions are reported and left in place."
				return 0
				;;
			*) echo "Unknown flag: $1"; return 1 ;;
		esac
	done

	local -a sources
	if [ $# -gt 0 ]; then
		sources=("$@")
	else
		sources=("$HOME/Desktop" "$HOME/Downloads")
	fi

	local source item tags name month
	local moved=0 kept=0 skipped=0 bucketed=0 bucket_skipped=0 lifted=0 shots=0 shot_skipped=0 zipped=0 zip_skipped=0

	for source in "${sources[@]}"; do
		if [ ! -d "$source" ]; then
			echo "Not a directory: $source"
			return 1
		fi
	done

	[ "$dry_run" -eq 0 ] && mkdir -p "$dest"

	# ─────────────────────────────────────────
	# Step 1: sweep untagged items into Archives
	# ─────────────────────────────────────────
	for source in "${sources[@]}"; do
		for item in "$source"/*(N); do
			[ "$item" = "$dest" ] && continue
			name="${item:t}"

			# A browser is still writing these; moving them would corrupt the download.
			case "$name" in
				*.crdownload|*.download|*.part|*.partial) continue ;;
			esac

			# Spotlight exposes Finder tags here; "(null)" means the item has none.
			tags=$(mdls -raw -name kMDItemUserTags "$item" 2>/dev/null)
			if [ "$tags" != "(null)" ] && [ -n "$tags" ]; then
				kept=$((kept + 1))
				continue
			fi

			if [ -e "$dest/$name" ]; then
				echo "skip (exists in Archives): $item"
				skipped=$((skipped + 1))
				continue
			fi

			if [ "$dry_run" -eq 1 ]; then
				echo "would move: $item"
			else
				mv -n "$item" "$dest/"
			fi
			moved=$((moved + 1))
		done
	done

	# ─────────────────────────────────────────
	# Step 2: bucket Archives by creation month
	# ─────────────────────────────────────────
	# Invariant: current-month items sit flat in Archives; only past months get a MM-YY folder.
	local this_month
	this_month=$(date '+%m-%y')

	# A folder for the current month can only come from an older version of this
	# function or the month rolling over before a bucket was filled; lift its contents.
	if [ -d "$dest/$this_month" ]; then
		# Lift screenshots individually so step 3 re-sorts them into the top-level screenshot folder.
		for item in "$dest/$this_month"/screenshot/*(N) "$dest/$this_month"/*(N); do
			name="${item:t}"
			[ "$name" = "screenshot" ] && [ -d "$item" ] && continue
			if [ -e "$dest/$name" ]; then
				echo "skip (exists in Archives): $this_month/$name"
				bucket_skipped=$((bucket_skipped + 1))
				continue
			fi
			if [ "$dry_run" -eq 1 ]; then
				echo "would lift out of $this_month: $name"
			else
				mv -n "$item" "$dest/"
			fi
			lifted=$((lifted + 1))
		done
		# rmdir only removes empty directories, so leftovers from collisions survive.
		if [ "$dry_run" -eq 0 ]; then
			rmdir "$dest/$this_month/screenshot" 2>/dev/null
			rmdir "$dest/$this_month" 2>/dev/null
		fi
	fi

	for item in "$dest"/*(N); do
		name="${item:t}"

		# Month folders are the buckets themselves, month zips are step 4's output, and
		# the top-level screenshot folder is step 3's; none is ever bucketed.
		[[ "$name" == [0-9][0-9]-[0-9][0-9] ]] && [ -d "$item" ] && continue
		[[ "$name" == [0-9][0-9]-[0-9][0-9].zip ]] && continue
		[ "$name" = "screenshot" ] && [ -d "$item" ] && continue

		# %SB is the birth time; mv preserves it, so swept items keep their original month.
		month=$(stat -f '%SB' -t '%m-%y' "$item" 2>/dev/null)
		if [ -z "$month" ]; then
			echo "skip (no creation date): $name"
			bucket_skipped=$((bucket_skipped + 1))
			continue
		fi

		[ "$month" = "$this_month" ] && continue

		if [ -e "$dest/$month/$name" ]; then
			echo "skip (exists in $month): $name"
			bucket_skipped=$((bucket_skipped + 1))
			continue
		fi

		if [ "$dry_run" -eq 1 ]; then
			echo "would bucket into $month: $name"
		else
			mkdir -p "$dest/$month"
			mv -n "$item" "$dest/$month/"
		fi
		bucketed=$((bucketed + 1))
	done

	# ─────────────────────────────────────────
	# Step 3: gather screenshots into a screenshot folder per month
	# ─────────────────────────────────────────
	# Runs before zipping so archived months carry their screenshot folder inside the zip.
	local bucket
	for bucket in "$dest" "$dest"/[0-9][0-9]-[0-9][0-9](N/); do
		for item in "$bucket"/Screenshot*.png(N.); do
			name="${item:t}"
			if [ -e "$bucket/screenshot/$name" ]; then
				echo "skip (exists in ${bucket:t}/screenshot): $name"
				shot_skipped=$((shot_skipped + 1))
				continue
			fi
			if [ "$dry_run" -eq 1 ]; then
				echo "would move into ${bucket:t}/screenshot: $name"
			else
				mkdir -p "$bucket/screenshot"
				mv -n "$item" "$bucket/screenshot/"
			fi
			shots=$((shots + 1))
		done
	done

	# ─────────────────────────────────────────
	# Step 4: zip month folders older than 2 months
	# ─────────────────────────────────────────
	# Age is counted in whole calendar months from the current month, so in October
	# 08-26 is 2 months old and stays a folder while 07-26 is 3 months old and gets zipped.
	local now_index folder_index age mm yy
	now_index=$(( $(date '+%Y') * 12 + ${$(date '+%m')#0} ))

	for item in "$dest"/[0-9][0-9]-[0-9][0-9](N/); do
		name="${item:t}"
		mm="${name[1,2]}"
		yy="${name[4,5]}"
		# Strip the leading zero so 08 and 09 are not read as invalid octal.
		folder_index=$(( (2000 + ${yy#0}) * 12 + ${mm#0} ))
		age=$(( now_index - folder_index ))
		[ "$age" -le 2 ] && continue

		if [ -e "$dest/$name.zip" ]; then
			echo "skip (zip exists, folder left in place): $name"
			zip_skipped=$((zip_skipped + 1))
			continue
		fi

		if [ "$dry_run" -eq 1 ]; then
			echo "would zip: $name"
			zipped=$((zipped + 1))
			continue
		fi

		# ditto keeps Finder metadata; the folder is removed only once the zip tests clean.
		if ditto -c -k --sequesterRsrc --keepParent "$item" "$dest/$name.zip" \
			&& unzip -tqq "$dest/$name.zip" >/dev/null 2>&1; then
			rm -rf "$item"
			echo "zipped: $name"
			zipped=$((zipped + 1))
		else
			echo "zip failed, folder left in place: $name"
			rm -f "$dest/$name.zip"
			zip_skipped=$((zip_skipped + 1))
		fi
	done

	echo ""
	if [ "$dry_run" -eq 1 ]; then
		echo "Dry run: $moved would move to $dest ($kept tagged kept, $skipped skipped);"
		echo "         $bucketed would bucket by month, $lifted would lift out of $this_month ($bucket_skipped skipped);"
		echo "         $shots screenshots would gather ($shot_skipped skipped);"
		echo "         $zipped month folders would zip ($zip_skipped skipped)."
	else
		echo "Moved $moved into $dest ($kept tagged kept, $skipped skipped);"
		echo "bucketed $bucketed by month, lifted $lifted out of $this_month ($bucket_skipped skipped);"
		echo "gathered $shots screenshots ($shot_skipped skipped);"
		echo "zipped $zipped month folders ($zip_skipped skipped)."
	fi
}
