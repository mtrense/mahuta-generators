# encoding: UTF-8
# Copyright 2017 Max Trense
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#   http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module Mahuta::Generators
  
  module Java
    
    def java_type(node)
      type = node[:type]
      case node[:many]
      when nil, false
        java_type_name(type)
      when true, :unordered
        "Set<#{java_type_name(type)}>"
      when :ordered
        "List<#{java_type_name(type)}>"
      end
    end
    
    def java_type_name(type)
      case type
      when :int, :integer
        'Integer'
      when :float
        'Float'
      when :string, :email, :phone_number
        'String'
      when :url
        'URL'
      else
        type.to_s.camelize(:upper)
      end
    end
    
    def java_variable_name(name)
      name.to_s.camelize(:lower)
    end
    
    def java_imports(type)
      
    end
    
    def path_for_type(node)
      target + [*node.namespace, *node.namespace_postfix, "#{java_type_name(node[:name])}.java"].collect(&:to_s).join('/')
    end
    
  end
  
end