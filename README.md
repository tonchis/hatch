Hatch
=====

Installation
------------

    $ gem install hatch

Usage
-----

An address without a street? A person without a name? Those are not valid objects!
Why should you have them hanging around your system?

Tell `Hatch` how to certify the attributes of your models, and he will give you
the appropriate object.

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
address.valid?
# => true

not_an_address = Address.hatch(street: '', number: 1234)
not_an_address.class
# => Address::InvalidAddress
not_an_address.valid?
# => false
```

You declare your attributes to `Hatch` with the `attributes` message and
then use `certify(:attribute, 'error message', &validation)` to verify when an
attribute is valid.

In case you're wondering, the `Model::InvalidModel` is polymorphic with your
`Model` in all the reader methods declared by `attr_reader` or `attr_accessor`

`Hatch` also supports some common validations we all like to have! You can pass an error
of your own or just use the default.

```ruby
class Address
  include Hatch
  attributes :street, :number

  certifies(:street, :presence, "This is an error! Where's my street?!")
  certifies(:number, :positive_number)
end
```

Common validations come in the following flavours (along with default errors)

  * `:presence` - `"must be present"`
  * `:positive_number` - `"must be a positive number"`

Aaand that's it for the moment. I'll keep on adding more as they come to my mind. If they come
to yours first, feel free to add them and PR.

Errors
------

You'll also get a handy `errors` hash with a couple of super powers.

```ruby
not_an_address = Address.hatch(street: '', number: 1234)
not_an_address.class
# => Address::InvalidAddress

not_an_address.errors.full_messages
# => ['Address must have a street']

not_an_address.errors.on(:street)
# => 'Address must have a street'

not_an_address.errors[:number]
# => []

not_an_address.errors.empty?
# => false
```

Thanks
------

To [@pote](https://github.com/pote) for the help, support and company!

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

