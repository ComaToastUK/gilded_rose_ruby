class GildedRose

  MINIMUM_QUALITY = 0

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      if item.name == 'Aged Brie'
        brie(item)
      elsif item.name == "Sulfuras, Hand of Ragnaros"
        sulfuras(item)
      elsif item.name == "Backstage passes to a TAFKAL80ETC concert"
        backstage(item)
      elsif item.name == 'Conjured Mana Cake'
        conjured(item)
      else
        normal_item(item)
      end
    end
  end

  def normal_item(item)
    item.sell_in -= 1
    item.quality = 0 if item.quality <= 0
    return if item.quality <= 0
    item.quality -= 1
    item.quality -= 1 if item.sell_in <= 0
  end

  def brie(item)
    item.sell_in -= 1
    return if item.quality >= 50
    item.quality += 1
    item.quality += 1 if item.sell_in <= 0
  end

  def sulfuras(item)
    return
  end

  def backstage(item)
    item.sell_in -= 1
    return if item.quality >= 50
    return item.quality = 0 if item.sell_in < 0
    item.quality += 1
    item.quality += 1 if item.sell_in < 10
    item.quality += 1 if item.sell_in < 5
  end

  def conjured(item)
    item.sell_in -= 1
    item.quality = 0 if item.quality <= 0
    return if item.quality <= 0
    item.quality -=2
  end

end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
