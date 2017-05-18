# frozen_string_literal: true

# Copyright 2016 New Context Services, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "kitchen/terraform/client"
require "kitchen/terraform/client/execute_command"

# Command to retrieve the version
::Kitchen::Terraform::Client::Version = lambda do |config:, logger:|
  catch :success do
    ::Kitchen::Terraform::Client::ExecuteCommand.call(command: "version", config: config, logger: logger)
  end.tap do |output|
    /v(\d+\.\d+)/.match output do |match_data|
      throw :success, Float(match_data[1])
    end
    throw :failure, "Terraform client version output did not contain a string matching 'vX.Y'"
  end
end