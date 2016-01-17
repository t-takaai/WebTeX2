# パッケージの読み込み
require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sqlite3'

class FileUpload < Sinatra::Base
  configure do
    enable :static
    enable :sessions
  end

# データベースから読み込み
  db = SQLite3::Database.new "db/post.db"
  db.results_as_hash = true # ハッシュとして返し，カラム名でアスセス

  get '/' do
    posts = db.execute("SELECT file_name FROM posts ORDER BY id DESC")
    erb :index, { :locals => { :posts => posts } }
  end

  post '/' do
    file_name = ""

    if params["file"]
      tempfile = params[:file][:tempfile]
      filename = params[:file][:filename]
      target = "./public/uploads/#{filename}"

      File.open(target, 'wb') do |f|
         f.write tempfile.read
      end

    else
      return "ファイルが必須です"
    end

    redirect '/'
  end
end

FileUpload.run!
