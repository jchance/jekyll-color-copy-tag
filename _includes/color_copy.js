<script>
function copyToClipboard(text, element) {
  if (!navigator.clipboard) return;

  navigator.clipboard.writeText(text).then(function () {
    if (!element) return;
    
    const originalInnerHTML = element.innerHTML;
    const originalBackground = window.getComputedStyle(element).backgroundColor;
    const copiedColor = element.dataset.copiedColor || "#2BB3B1";
    
    // Checkmark icon (check-lg from Bootstrap Icons)
    const checkmarkIcon = '<svg xmlns="http://www.w3.org/2000/svg" aria-hidden="true" focusable="false" viewBox="0 0 16 16" width="1em" height="1em" style="margin-right: 0.35em; vertical-align: -0.125em; fill: currentColor;"><path d="M12.736 3.97a.733.733 0 0 1 1.047 0c.286.289.29.756.01 1.05L7.88 12.01a.733.733 0 0 1-1.065.02L3.217 8.384a.757.757 0 0 1 0-1.06.733.733 0 0 1 1.047 0l3.052 3.093 5.4-6.425z"/></svg>';
     
    // Detect if this is a swatch (has class color-copy-swatch) or button
    const isSwatch = element.classList.contains('color-copy-swatch');
    const copiedContent = isSwatch ? checkmarkIcon : checkmarkIcon + ' Copied';
     
    // Replace with checkmark (swatch) or checkmark + text (button)
    element.innerHTML = copiedContent;
    element.style.background = copiedColor;
    
    setTimeout(function () {
      element.innerHTML = originalInnerHTML;
      element.style.background = originalBackground;
    }, 1200);
  });
}
</script>
