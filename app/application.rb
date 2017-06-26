class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/cart/)
      get_cart.each {|val| resp.write val}
    elsif req.path.match(/add/)
      search_term = req.params["item"]
      resp.write item_available?(search_term) ? add_item_to_cart(search_term) : "We don't have that item"
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def get_cart
    @@cart.empty? ? ["Your cart is empty\n"] : @@cart.map {|cart_item| "#{cart_item}\n"}
  end

  def add_item_to_cart(item)
    @@cart << item
    "added #{item}"
  end

  def item_available?(search_term)
    handle_search(search_term) != "Couldn't find #{search_term}"
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end
