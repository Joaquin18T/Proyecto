document.addEventListener("DOMContentLoaded",()=>{
  const sidebarList = document.getElementById('options-sidebar');

  sidebarList.addEventListener("click",(e)=>{
    if (e.target && e.target.matches("a.nav-link")) {
      const aElement = document.querySelectorAll(".nav-link");
      aElement.forEach(x=>{
        x.addEventListener("click",(e)=>{
          e.preventDefault();
          const hrefValue = enlace.href;
          window.location.href= hrefValue;
        });
      });

      
      let items = sidebarList.querySelectorAll('li');
      items.forEach(item => item.classList.remove('active'));
      
      // Añadir la clase active al li seleccionado
      e.target.parentElement.classList.add('active');
    }
  });
});