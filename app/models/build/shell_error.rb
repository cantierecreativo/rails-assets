module Build
  class ShellError < BuildError
    attr_reader :path, :command

    def initialize(message, path = nil, command = nil)
      @path = path
      @command = command

      super(message)
    end
  end
end
