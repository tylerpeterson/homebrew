require 'formula'

class Maven2 < Formula
  # NOTE: Based on https://github.com/adamv/homebrew-alt/blob/master/versions/maven2.rb
  # But intended to co-exist with maven3

  homepage 'http://maven.apache.org/'
  url 'http://www.apache.org/dist/maven/binaries/apache-maven-2.2.1-bin.tar.gz'
  homepage 'http://maven.apache.org/'
  md5 '3f829ed854cbacdaca8f809e4954c916'

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Install jars in libexec to avoid conflicts
    prefix.install %w{ NOTICE.txt LICENSE.txt README.txt }
    libexec.install Dir['*']

    # Symlink binaries
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |f|
      ln_s f, bin+add2ToName(File.basename(f))
    end
  end

  def add2ToName (name)
    if name == "mvn" then
      name = "mvn2"
    end
    if name == "mvnDebug" then
      name = "mvn2Debug"
    end
    return name
  end

  def caveats; <<-EOS.undent
    Installs the binary as mvn2 so it won't conflict with already installed maven.
    By default, M2_HOME is set to /usr/share/maven, which makes this freshly installed
    mvn2 binary choke.  To make both mvn and mvn2 work, unset the M2_HOME variable
    in your .bash_profile. This is as simple as adding the following to .bash_profile
    in your home directory (or creating that file if it doesn't exist yet and adding
    this to it):

        unset M2_HOME

    EOS
  end
end
