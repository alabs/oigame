class CreateCdrs < ActiveRecord::Migration
  def change
    create_table :cdrs do |t|
      t.datetime  :calldate
      t.string  :clid
      t.string  :src
      t.string  :dst
      t.string  :dcontext
      t.string  :channel
      t.string  :dstchannel
      t.string  :lastapp
      t.string  :lastdata
      t.integer :duration
      t.integer :billsec
      t.string  :disposition
      t.integer :amaflags
      t.string  :accountcode
      t.string  :uniqueid
      t.string  :userfield
      t.string  :peeraccount
      t.string  :linkedid
      t.integer :sequence

      t.timestamps
    end
  end
end
