require 'minitest/autorun'
require 'ruby_projection'

class TestProjectionObject < OpenStruct
	def method_with_args(*args)
		args
	end
end

describe RubyProjection do
	let(:hsh) {
		{
			attr: :a,
			bttr: :b,
			arrttr: [
				OpenStruct.new(attr: :a1, bttr: :b1),
				OpenStruct.new(attr: :a2, bttr: :b2)
			]
		}
	}
	let(:object) { TestProjectionObject.new(hsh) }
	let(:array) { [hsh, object, object, hsh] }

	describe '#proj' do
		it 'should pass through nil' do
			RubyProjection.proj(nil).must_be_nil
		end

		[:hsh, :object, :array].each do |k|
			describe "#{k} data" do
				let(:data) { public_send(k) }
				define_method(:all_equal) { |a, b|
					if k == :array
						a.each { |x| x.must_equal(b) }
					else
						a.must_equal(b)
					end
				}

				it 'should filter out everything by default' do
					all_equal RubyProjection.proj(data), {}
				end

				describe 'direct attributes' do
					it 'should pass through one attribute' do
						all_equal RubyProjection.proj(data, :attr), {attr: :a}
					end

					it 'should pass through two attributes' do
						all_equal RubyProjection.proj(data, :attr, :bttr), {attr: :a, bttr: :b}
					end
				end

				describe 'simple attribute renames' do
					it 'should rename one attribute' do
						all_equal RubyProjection.proj(data, zttr: :attr), {zttr: :a}
					end

					it 'should rename two attributes' do
						all_equal RubyProjection.proj(data, zttr: :attr, xttr: :bttr), {zttr: :a, xttr: :b}
					end
				end

				describe 'simple transformation' do
					it 'should transform one attribute with proc' do
						all_equal RubyProjection.proj(data, attr: :to_s.to_proc), {attr: 'a'}
					end

					it 'should transform one attribute with explicit lambda' do
						all_equal RubyProjection.proj(data, attr: lambda {|x| x.to_s}), {attr: 'a'}
					end
				end

				describe 'array syntax' do
					describe 'no transformation' do
						it 'should rename attributes' do
							all_equal RubyProjection.proj(data, zttr: [from: :attr]), {zttr: :a}
						end
					end

					describe 'with transformation' do
						it 'should transform using symbol' do
							all_equal RubyProjection.proj(data, attr: [:to_s]), {attr: 'a'}
						end

						it 'should transform using proc' do
							all_equal RubyProjection.proj(data, attr: [:to_s.to_proc]), {attr: 'a'}
						end

						it 'should transform using explicit lambda' do
							all_equal RubyProjection.proj(data, attr: [lambda {|x| x.to_s}]), {attr: 'a'}
						end

						it 'should rename attributes' do
							all_equal RubyProjection.proj(data, zttr: [:to_s, from: :attr]), {zttr: 'a'}
						end

					end
				end
			end
		end

		describe 'array syntax passing arguments' do
			describe 'no transformation' do
				it 'should pass one argument' do
					RubyProjection.proj(object, method_with_args: [with: 1]).must_equal({method_with_args: [1]})
				end

				it 'should pass multiple arguments' do
					RubyProjection.proj(object, method_with_args: [with: [1,2]]).must_equal({method_with_args: [1,2]})
				end

				it 'should rename and pass arguments' do
					RubyProjection.proj(object, zattr: [from: :method_with_args, with: [1,2]]).must_equal({zattr: [1,2]})
				end
			end

			describe 'with transformation' do
				it 'should pass one argument' do
					RubyProjection.proj(object, method_with_args: [:to_s, with: 1]).must_equal({method_with_args: '[1]'})
				end

				it 'should pass multiple arguments' do
					RubyProjection.proj(object, method_with_args: [:to_s, with: [1,2]]).must_equal({method_with_args: '[1, 2]'})
				end
			end
		end
	end

	describe '#nested' do
		it 'should delay taking in the object' do
			RubyProjection.nested(:attr)[object].must_equal({attr: :a})
		end

		describe 'using partial template' do
			it 'should find and use' do
				skip
			end

			it 'should pass through locals directly' do
				skip
			end

			it 'should pass through locals from :locals' do
				skip
			end

			it 'should default object name to file name' do
				skip
			end

			it 'should accept override for object name' do
				skip
			end
		end
	end
end
