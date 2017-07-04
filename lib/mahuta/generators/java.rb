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
      when :bool, :boolean
        'Boolean'
      when :int, :integer
        'Integer'
      when :float
        'Float'
      when :long, :long_integer
        'Long'
      when :string, :email, :phone_number
        'String'
      when :url
        'URL'
      when :date
        'org.joda.time.DateTime'
      when :binary
        'byte[]'
      else
        java_class_name(type)
      end
    end

    def java_class_name(type)
        type.to_s.camelize(:upper)
    end

    def java_namespace(node)
      namespace_with_postfix(node).collect {|nc| nc.to_s.camelize(:lower) }.join('.')
    end

    def java_variable_name(name)
      name.to_s.camelize(:lower)
    end

    def java_constant_name(name)
      name.to_s.upcase
    end

    def java_import(node)
      type_node = node.root.descendants {|descendant| descendant.name == node.type}.first
      java_namespace(type_node) + '.' + java_class_name(type_node.name)
    end

    def namespace_with_postfix(node) 
      if node.respond_to? :namespace_postfix
        node.namespace + node.namespace_postfix
      else
        node.namespace
      end
    end

    def path_for_type(node)
      namespace = namespace_with_postfix(node)

      ns = namespace.collect {|nc| nc.to_s.camelize(:lower) }
      target + [*ns, "#{java_type_name(node[:name])}.java"].collect(&:to_s).join('/')
    end

  end

end
