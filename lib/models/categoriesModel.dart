class CategoriesModel {
  String image;
  String title;

  CategoriesModel({this.image, this.title});
}

List<CategoriesModel> categoriesModel = [
  CategoriesModel(
    image: "assets/icons/male.svg",
    title: "Male",
  ),
  CategoriesModel(
    image: "assets/icons/female.svg",
    title: "Female",
  ),
  // CategoriesModel(
  //   image: "assets/icons/backpack.svg",
  //   title: "Backpack",
  // ),
];
