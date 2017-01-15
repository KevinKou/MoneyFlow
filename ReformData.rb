module ReformData
	def ClassifyData(targetFilePath)

		@src_filePath   = targetFilePath
		@destFilePath   = File.basename(targetFilePath, ".csv") + "_reformed.csv"
		fileBaseName 	= File.basename(targetFilePath).upcase

		if fileBaseName.include?("AMEX")
			reformData_AMEX
		elsif fileBaseName.include?("UFJ")
			reformData_UFJ
		elsif fileBaseName.include?("RESONA")
			reformData_Resona
		end

		# ofx_reformed = File.open(destFilePath,"w")
		# ofx_reformed.puts("日付,金額,支払い先")
		# File.foreach (srcFilePath) do |line|
		# 	ofx_reformed.puts(line.encode("UTF-8","Shift_JIS"))
		# end
		# ofx_reformed.close
	end

	def reformData_AMEX
		puts "amex"
		puts @destFilePath
		dest_file = File.open(@destFilePath, "w")
		dest_file.puts("口座,説明,受取人,カテゴリ,日付,金額,タグ,")
		account = "AMEX"
		File.foreach (@src_filePath) do |line|
			line_utf8 = line.encode("UTF-8","Shift_JIS").split(",")
			descript = ""
			payto  = line_utf8[2]
			kategorie = payto	# <- ここは判定する箇所いる
			data = line_utf8[0]
			price = line_utf8[1]
			tag = payto # <- ここは判定する箇所いる
			line_str = account + "," + descript + "," + payto + "," + kategorie + "," + data + "," + price + "," + tag + ","
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

	module_function :ClassifyData	# <- これがないと外部から呼び出せない
	module_function :reformData_AMEX
	module_function :reformData_UFJ
	module_function :reformData_Resona
end