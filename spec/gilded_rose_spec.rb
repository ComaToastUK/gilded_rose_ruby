require './lib/gilded_rose.rb'

describe GildedRose do

  describe '#update_quality' do

    it 'does not change the name' do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality
      expect(items[0].name).to eq 'foo'
    end

    it 'reduces sell_in by one on each tick' do
      items = [Item.new('foo', 5, 5)]
      GildedRose.new(items).update_quality
      expect(items[0].sell_in).to eq(4)
    end

    it 'reduces item quality on each tick' do
      items = [Item.new('foo', 5, 5)]
      expect { GildedRose.new(items).update_quality }.to change { items[0].quality }.to(4)
    end

    it 'reduces sell_in by n in n days' do
      n = 8
      items = [Item.new('foo', 10, 10)]
      n.times do
        GildedRose.new(items).update_quality
      end
      expect(items[0].sell_in).to eq(2)
    end

    it 'reduces quality by double after sell_in has passed 0' do
      items = [Item.new('foo', 5, 9)]
      n = 5
      n.times do
        GildedRose.new(items).update_quality
      end
      expect { GildedRose.new(items).update_quality }.to change { items[0].quality }.to(1)
    end

    it 'can have a negative sell_in value' do
      items = [Item.new('foo', 0, 0)]
      expect { GildedRose.new(items).update_quality }.to change { items[0].sell_in }.to(-1)
    end
  end

  context 'item degradation cannot exceed 0' do
    it 'has a minimum item quality of 0' do
      items = [Item.new('foo', 10, 10)]
      n = 11
      n.times do
        GildedRose.new(items).update_quality
      end
      expect(items[0].sell_in).to eq(-1)
      expect(items[0].quality).to eq(0)
    end
  end

  context 'item quality cannot exceed maximum value' do
    it 'has a maximum quality value of 50' do
      items = [Item.new('foo', 10, 50)]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to be < 50
    end
  end

  context 'legendary item does not degrade' do
    it 'does not degrade if it is Sulfuras' do
      items = [Item.new('Sulfuras, Hand of Ragnaros', 10, 50)]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq(50)
    end
  end

  context 'legendary item does not reduce sell_in value' do
    it 'does not reduce sell_in if it is Sulfuras' do
      items = [Item.new('Sulfuras, Hand of Ragnaros', 10, 50)]
      GildedRose.new(items).update_quality
      expect(items[0].sell_in).to eq(10)
    end
  end

  context 'aged brie gains in quality over time' do
    it 'gains in quality after sell_in if it is Aged Brie' do
      items = [Item.new('Aged Brie', 2, 2)]
      n = 20
      n.times do
        GildedRose.new(items).update_quality
      end
      expect(items[0].quality).to eq(41)
    end
  end

  context 'backstage passes gain in quality over time' do
    it 'increases in quality if it is Backstage Passes' do
      items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 15, 10)]
      n = 4
      n.times do
        GildedRose.new(items).update_quality
      end
      expect(items[0].quality).to eq(14)
    end

    it 'doubles its quality increase after sell_in < 10 if it is Backstage Passes' do
      items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 15, 10)]
      n = 6
      n.times do
        GildedRose.new(items).update_quality
      end
      expect(items[0].quality).to eq(17)
    end

    it 'triples its quality increase after sell_in < 5 if it is Backstage Passes' do
      items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 15, 10)]
      n = 11
      n.times do
        GildedRose.new(items).update_quality
      end
      expect(items[0].quality).to eq(28)
    end
  end

  context 'backstage passes quality depeciates to 0 after sell_in reaches 0' do
    it 'drops to 0 quality after sell_in <= 0 if it is Backstage Passes' do
      items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 15, 10)]
      n = 16
      n.times do
        GildedRose.new(items).update_quality
      end
      expect(items[0].quality).to eq(0)
      expect(items[0].sell_in).to eq(-1)
    end
  end

  it 'degrades at double the rate of other items if it is Conjured' do
    items = [Item.new('Conjured Mana Cake', 3, 6)]
    n = 3
    n.times do
      GildedRose.new(items).update_quality
    end
    expect(items[0].quality).to eq(0)
  end
end
