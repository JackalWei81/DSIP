namespace :upload do
  #上傳原始資料
  #Todo:
  #  1.思考更聰明的資料分類方式
  #  2.將檔案讀入buffer後再處理，以便可pass單行資料後續處理
  task data: :environment do
    puts "Start Upload~~"

    Dir.glob("public/ori_data/*").each do |filename|
      begin
        file = File.new(filename, 'r')
        puts filename
        count = 0
        while(line = file.gets)
          count += 1
          #資料處理 => 過濾及整理
          unless line == "\r\n"
            list = line.split(" ")
            ip_start = ip_end = province = city = nil
            ip_start = list[0] if list[0].split(".").count == 4
            ip_end = list[1] if list[1].split(".").count == 4
            if list[2].index("省")
              province = list[2].split("省").first

              temp = list[2].split("省").last
              city = temp.split("市").first if temp.index("市")
              description = list[2]
              remark = list[3]
            else
              city = list[2].split("市").first if list[2].index("市")
              description = list[2]
              remark = list[3]
            end
            #puts "#{ip_start}, #{ip_end}, #{province}省, #{city}市"
          end

          #存入資料庫
          if OriDataTable.where("ip_start = ? AND ip_end = ?", ip_start, ip_end).empty?
            OriDataTable.create!(ip_start: ip_start, ip_end: ip_end, province: province, city: city, description: description, remark: remark)
          end
        end
      rescue
        count == 0 ? (puts "#{filename}，非可處理之檔案類型") : (puts "檔案#{filename}中，第#{count}行資料格式有誤")
      end
    end
  end

end