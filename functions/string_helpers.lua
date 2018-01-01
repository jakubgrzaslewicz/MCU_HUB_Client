local publicClass={};
function publicClass.trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end
return publicClass; 
