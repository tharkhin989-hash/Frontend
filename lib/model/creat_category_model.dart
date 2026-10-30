class CreateCategory{
 final String name;
 final String description;
 

 const CreateCategory({
   required this.name,
   required this.description,
   
});
 Map<String, dynamic> toJson() {
  return {
    'name': name,
    'description': description,
    
  };
 }
}