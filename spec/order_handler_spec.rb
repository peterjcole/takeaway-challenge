require 'order_handler'

describe 'order_handler' do

  let(:order_class) { double(:order, new: order) }
  let(:order) { double(:order, delivery_time: "18:01").as_null_object }
  let(:order_handler) { OrderHandler.new(menu, order_class) }
  let(:pizza) { double(:dish, name: "Pizza", price: BigDecimal(1.51, 4), to_s: "Pizza: £1.50") }
  let(:sushi) { double(:dish, name: "Sushi", price: BigDecimal(16, 4), to_s: "Sushi: £16.00") }
  let(:dishes) do
    {
      "Pizza" => pizza,
      "Sushi" => sushi
    }
  end
  let(:menu) { double(:menu) }
  before(:each) do
    allow(menu).to receive(:get)
    allow(menu).to receive(:get).with("Pizza").and_return(pizza)
    allow(menu).to receive(:get).with("Sushi").and_return(sushi)
  end
  let(:time) { Time.now }

  context '#handle_order' do
    context 'when ordering one item' do
      context 'when total is correct' do
        it 'creates a new order' do
          allow(order).to receive(:total).and_return(BigDecimal(1.50, 4))
          expect(order_class).to receive(:new).with(time)
          order_handler.handle_order("Pizza *1", 1.50, time)
        end

        it 'calls the add method on the order, with the correct dish object' do
          allow(order).to receive(:total).and_return(BigDecimal(1.50, 4))
          expect(order).to receive(:add).with(pizza)
          order_handler.handle_order("Pizza *1", 1.50)
        end

        it 'returns a friendly string' do
          allow(order).to receive(:total).and_return(BigDecimal(1.50, 4))
          expected_output = "Thank you! Your order was placed and will be delivered before 18:01. You will also receive a text message with these details"
          expect(order_handler.handle_order("Pizza *1", 1.50)).to eq(expected_output)
        end

        it 'sends a text message' 

      end

      context 'when total is incorrect' do
        it 'raises an error' do
          allow(order).to receive(:total).and_return(BigDecimal(1.50, 4))
          expect{ order_handler.handle_order("Pizza *1", 1) }.to raise_error(OrderHandler::ERROR_MESSAGE)
        end
      end

      context 'with an invalid item' do
        it 'raises an error' do
          allow(order).to receive(:total).and_return(BigDecimal(1.50, 4))
          expect{ order_handler.handle_order("Pie *1", 1.50) }.to raise_error(OrderHandler::ERROR_MESSAGE)
        end
      end
    end

    context 'when ordering multiple items' do
      context 'ordering multiple items with the correct total'
        it 'creates a new order' do
          allow(order).to receive(:total).and_return(BigDecimal(33.50, 4))
          expect(order_class).to receive(:new)
          order_handler.handle_order("Pizza *1, Sushi *2", 33.50)
        end

        it 'calls the add method on the order, with the correct dish object' do
          allow(order).to receive(:total).and_return(BigDecimal(33.50, 4))
          expect(order).to receive(:add).with(pizza)
          expect(order).to receive(:add).with(sushi).twice
          order_handler.handle_order("Pizza *1, Sushi *2", 33.50)
        end

        it 'returns a friendly string' do
          allow(order).to receive(:total).and_return(BigDecimal(33.50, 4))
          expected_output = "Thank you! Your order was placed and will be delivered before 18:01. You will also receive a text message with these details"
          expect(order_handler.handle_order("Pizza *1, Sushi *2", 33.50)).to eq(expected_output)
        end

        it 'sends a text message' 

      context 'with invalid inputs' do
        it 'raises an error when total is incorrect' do
          allow(order).to receive(:total).and_return(BigDecimal(1.50, 4))
          expect{ order_handler.handle_order("Pizza *1, Sushi *2", 1) }.to raise_error(OrderHandler::ERROR_MESSAGE)
        end
        it 'raises an error with an invalid item' do
          allow(order).to receive(:total).and_return(BigDecimal(1.50, 4))
          expect{ order_handler.handle_order("Pizza *1, Pie *2", 1.50) }.to raise_error(OrderHandler::ERROR_MESSAGE)
        end
        it 'raises an error when spaces are missing' do
          allow(order).to receive(:total).and_return(BigDecimal(33.50, 4))
          expect{ order_handler.handle_order("Pizza*1, Sushi *2", 1.50) }.to raise_error(OrderHandler::ERROR_MESSAGE)
        end
        it 'raises an error when values are missing' do
          allow(order).to receive(:total).and_return(BigDecimal(33.50, 4))
          expect{ order_handler.handle_order("Pizza *, Sushi *2", 1.50) }.to raise_error(OrderHandler::ERROR_MESSAGE)
        end
        it 'raises an error with a strange string' do
          allow(order).to receive(:total).and_return(BigDecimal(33.50, 4))
          expect{ order_handler.handle_order("PizzaSushi", 1.50) }.to raise_error(OrderHandler::ERROR_MESSAGE)
        end
        it 'raises an error with middle space missing' do
          allow(order).to receive(:total).and_return(BigDecimal(33.50, 4))
          expect{ order_handler.handle_order("Pizza *1,Sushi *2", 1.50) }.to raise_error(OrderHandler::ERROR_MESSAGE)
        end
      end
    end

  end
end