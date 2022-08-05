# frozen_string_literal: true

require "decidim/gem_manager"

namespace :decidim_donations do
  namespace :webpacker do
    desc "Installs Decidim Donations webpacker files in Rails instance application"
    task install: :environment do
      raise "Decidim gem is not installed" if decidim_path.nil?
    end

    desc "Adds Decidim Donations dependencies in package.json"
    task upgrade: :environment do
      raise "Decidim gem is not installed" if decidim_path.nil?
    end


    def donations_path
      @donations_path ||= Pathname.new(donations_gemspec.full_gem_path) if Gem.loaded_specs.has_key?(gem_name)
    end

    def donations_gemspec
      @donations_gemspec ||= Gem.loaded_specs[gem_name]
    end

    def rails_app_path
      @rails_app_path ||= Rails.root
    end

    def copy_awesome_file_to_application(origin_path, destination_path = origin_path)
      FileUtils.cp(donations_path.join(origin_path), rails_app_path.join(destination_path))
    end

    def system!(command)
      system("cd #{rails_app_path} && #{command}") || abort("\n== Command #{command} failed ==")
    end

    def gem_name
      "decidim-donations"
    end
  end
end
