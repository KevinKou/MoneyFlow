require 'csv'

module ReformData

	def ClassifyData(targetFilePath)
		@src_filePath   = targetFilePath
		@destFilePath   = File.basename(targetFilePath, ".xls") + "_reformed.csv"
		fileBaseName 	= File.basename(targetFilePath).upcase

		if fileBaseName.include?("AMEX")
			reformData_AMEX
		elsif fileBaseName.include?("UFJ")
			reformData_UFJ
		elsif fileBaseName.include?("RESONA")
			reformData_Resona
		end
	end

	def reformData_AMEX
		whichOS
		# puts "amex"
		# puts @destFilePath
		dest_file = File.open(@destFilePath, "w")
		dest_file.puts("口座,説明,受取人,カテゴリ,日付,金額,タグ,")

		account   = "AMEX"
		File.foreach (@src_filePath) do |line|
			if @os == :windows
				line_utf8 = line.split("	")
			elsif @os == :macosx
				line_utf8 = line.encode("UTF-8","Shift_JIS").split("	")
			end

			payto      = line_utf8[2].strip
			retrun_str = doClassify(payto) # <- ここは判定する箇所いる
			kategorie  = retrun_str[0]
			tag        = retrun_str[1]
			descript   = retrun_str[2]
			if descript == "skip"
				next
			end
			data       = line_utf8[0].strip
			price      = "-" + line_utf8[1].gsub("\"","").gsub(",","").strip
			line_str   = account + "," + descript + "," + payto + "," + kategorie + "," + data + "," + price + "," + tag + ","
			dest_file.puts(line_str)
		end
		dest_file.close
	end

	def reformData_UFJ
		puts "ufj"
		puts @src_filePath
	end

	def reformData_Resona
		puts "resona"
		puts @src_filePath
	end

	def whichOS
		@os ||= (
			host_os = RbConfig::CONFIG['host_os']
			case host_os
			when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
			  :windows
			when /darwin|mac os/
			  :macosx
			when /linux/
			  :linux
			when /solaris|bsd/
			  :unix
			else
			  :unknown
			end
		)
	end

	def doClassify(paytowho)
		kategorie_str = ""
		tag_str       = ""
		description   = ""

		define_info = CSV.read("./Classify_define.csv", headers: true)
		define_info.each {
			|define_data|
			if paytowho.include?(define_data["PayToWho"])
				if define_data["Kategorie"] != nil
					kategorie_str = define_data["Kategorie"]
				end
				if define_data["Tag"] != nil
					tag_str       = define_data["Tag"]
				end
				if define_data["Description"] != nil
					description   = define_data["Description"]
				end
			end
		}
		return kategorie_str, tag_str, description
	end

	module_function :ClassifyData	# <- これがない呼び出せない
	module_function :reformData_AMEX
	module_function :reformData_UFJ
	module_function :reformData_Resona
	module_function :whichOS
	module_function :doClassify
end
