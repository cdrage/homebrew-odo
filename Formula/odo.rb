class Odo < Formula
  desc "OpenShift Command-line for Developers"
  homepage "https://github.com/openshift/odo"
  
  url "https://github.com/openshift/odo.git",
  :tag      => "v1.2.1",
  :revision => "b7b7c2fac2290dd40496a1c08aba2ae543c751d4"
  
  head "https://github.com/openshift/odo.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath / "src/github.com/openshift/odo").install buildpath.children
    cd buildpath / "src/github.com/openshift/odo" do
      system "make", "bin"
      bin.install "odo"
    end
  end

  test do
    # all other odo commands require running OpenShift cluster
    version_output = shell_output("#{bin}/odo version 2>&1")

    tag = stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:tag]
    short_rev = stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision].slice(0, 8)
    assert_match tag, version_output
    assert_match short_rev, version_output
  end
end
