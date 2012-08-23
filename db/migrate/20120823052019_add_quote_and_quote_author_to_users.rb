class AddQuoteAndQuoteAuthorToUsers < ActiveRecord::Migration
  def change
    add_column :users, :quote, :string

    add_column :users, :quote_author, :string

  end
end
