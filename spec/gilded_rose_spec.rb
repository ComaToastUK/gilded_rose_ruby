require './lib/gilded_rose.rb'

describe GildedRose do

  subject(:gilded_rose) { described_class.new }

  describe "#update_quality" do
    it "does not change the name" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq "foo"
    end

    it 'reduces sell_in by one on each tick' do
      items = [Item.new("foo", 5, 5)]
      GildedRose.new(items).update_quality()
      expect(items[0].sell_in).to eq(4)
    end

    it 'reduces item quality on each tick' do
      items = [Item.new("foo", 5, 5)]
      expect {GildedRose.new(items).update_quality()}.to change { items[0].quality}.to(4)
    end

    it 'reduces sell_in by n in n days' do
      n = 8
      items = [Item.new("foo", 10, 10)]
      n.times do
        GildedRose.new(items).update_quality()
      end
      expect(items[0].sell_in).to eq(2)
    end

    it 'can have a negative sell_in value' do
      items = [Item.new("foo", 0, 0)]
      expect {GildedRose.new(items).update_quality()}.to change { items[0].quality}.to(-1)
    end
  end

end
