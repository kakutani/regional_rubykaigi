namespace :gettext do
  namespace :update do
    desc "update pot/po files"
    task :po do
      require 'gettext/utils'
      GetText.update_pofiles("regional", Dir.glob("{app,lib,bin}/**/*.{rb,erb,rjs}"), "regional 0.1.0")
    end
  end

  namespace :make do
    desc "create mo-files"
    task :mo do
      require 'gettext/utils'
      GetText.create_mofiles(true, "po", "locale")
    end
  end
end
