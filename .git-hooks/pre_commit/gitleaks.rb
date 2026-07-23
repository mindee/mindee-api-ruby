# frozen_string_literal: true

module Overcommit
  module Hook
    module PreCommit
      # Local script to run gitleaks
      class Gitleaks < Base
        # Runs the command.
        def run
          result = execute(['gitleaks', 'git', '--staged', '-v', '.'])

          return :pass if result.success?

          [:fail, result.stdout + result.stderr]
        end
      end
    end
  end
end
