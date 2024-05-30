RSpec.shared_examples 'ポスト・コメントのバリデーション' do
    context '投稿内容チェック' do
        it '投稿内容及び画像が空欄で、投稿ができない' do
            post.body =  nil
            expect(post).to be_invalid
        end
        it '投稿内容が画像有、内容は無しであり、投稿ができる' do
            post.body = nil
            post.image.attach(
                io: File.open(Rails.root.join('spec', 'fixtures', 'cat.jpg')),
                filename: 'cat.jpg',
                content_type: 'image/jpg'
                )
            expect(post).to be_valid
        end
        it '投稿内容が有り、画像が空欄で、投稿ができる' do
            post.body = Faker::Lorem.characters(number:50)
            expect(post).to be_valid
        end
        it '投稿内容が50文字以内であること' do
             post.body = Faker::Lorem.characters(number:51)
             expect(post).to be_invalid
             expect(post.errors[:body][0]).to match("50文字以内")
             post.body = Faker::Lorem.characters(number:50)
             expect(post).to be_valid
             
        end
    end
end