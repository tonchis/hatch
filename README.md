Hatch
=====

An address without a street? A person without a name? Those are not valid objects!
Why should you have them hanging around your system?

Tell ```Hatch``` how to certify the attribtues of your models, and he will give you
the appropiate object.

If you don't hatch your model with all the correct attributes, it will give you
an object representing an invalid instance of it.

```ruby
require 'hatch'

class Address
  include Hatch
  attributes :street, :number

  certify(:street, 'Address must have a street') do |street|
    !street.nil? && !street.empty?
  end

  certify(:number, 'Address must have a positive number') do |number|
    !number.nil? && number > 0
  end
end

address = Address.hatch(street: 'Fake St', number: 1234)
address.class
# => Address

not_an_address = Address.hatch(street: '', number: 1234)
address.class
# => Address::InvalidAddress
```

You declare your attributes to ```Hatch``` with the ```attribtues``` message and
then use ```certify(:attribute, 'error message', &validation)``` to verify when an
attribute is valid.

You'll also get some handy ```errors``` and ```valid?``` methods for both your valid
and invalid model instances.

```ruby
not_an_address = Address.hatch(street: '', number: 1234)
address.class
# => Address::InvalidAddress

address.errors
# => ['Address must have a street']

address.valid?
# => false
```

In case you're wondering, the ```Model::InvalidModel``` is polymorphic with your
```Model``` in all the reader methods declared by ```attr_reader``` or ```attr_accessor```

Installation
------------

    $ gem install hatch

Thanks
------

To @pote for the help, support and company!

License
-------

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

