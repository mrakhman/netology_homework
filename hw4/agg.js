/*
        Написать запрос, который выводит общее число тегов
*/
print("tags count: ", db.tags.count());

print(); // \n
print("tags count2:");
printjson(db.tags.aggregate([{$group: {_id: "total", tag_count: {$sum: 1}}}])['_batch']); // Another way is to use $group


/*
        Добавляем фильтрацию: считаем только количество тегов woman
*/
print(); // \n
print("woman tags count: ", db.tags.count({name: "woman"}));


/*
        Очень сложный запрос: используем группировку данных посчитать количество вхождений для каждого тега
        и напечатать top-3 самых популярных
*/

// Full request: db.tags.aggregate([{$group: {_id: "$name", tag_count: {$sum: 1}}}, {$sort: {tag_count: -1}}, {$limit: 3}])
print(); // \n
printjson(
        db.tags.aggregate([
                {$group: {
                                _id: "$name",
                                tag_count: {$sum: 1}
                           }
                },
                {$sort: {tag_count: -1}},
                {$limit: 3}
        ])['_batch']
);



