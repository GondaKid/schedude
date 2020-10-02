# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Subject.create(name: 'Đường lối cách mạng của Đảng Cộng sản Việt Nam', time: 'T2(1-5)-P.cs2:F305', details: '18CSH1')
Subject.create(name: 'Đường lối cách mạng của Đảng Cộng sản Việt Nam', time: 'T3(6-8)-P.cs2:F304', details: '18CTT2')
Subject.create(name: 'Cơ sở dữ liệu', time: 'T3(6-9)-P.TBSau', details: '18_1')
Subject.create(name: 'Hệ điều hành', time: 'T6(6-9)-P.TBSau', details: '18_21')
Subject.create(name: 'Cơ sở dữ liệu nâng cao', time: 'T4(1-4)-P.TBsau', details: '18_1')
Subject.create(name: 'Lập trình Windows', time: 'T2(6-9)-P.TBSau', details: '18_31')

Student.create(student_id: '18120514')
Student.create(student_id: '18120517')
Student.create(student_id: '18120519')
Student.create(student_id: '18120420')

Enrollment.create(student_id: '28', subject_id: '37')
Enrollment.create(student_id: '28', subject_id: '38')
Enrollment.create(student_id: '28', subject_id: '39')
Enrollment.create(student_id: '29', subject_id: '40')
Enrollment.create(student_id: '29', subject_id: '41')
Enrollment.create(student_id: '29', subject_id: '42')
Enrollment.create(student_id: '29', subject_id: '37')
Enrollment.create(student_id: '30', subject_id: '38')
Enrollment.create(student_id: '30', subject_id: '39')
Enrollment.create(student_id: '31', subject_id: '40')
Enrollment.create(student_id: '31', subject_id: '41')