//////////////////////////////////////////////////////
// shameless rip from https://stackoverflow.com/questions/17733076/smooth-scroll-anchor-links-without-jquery
//////////////////////////////////////////////////////
function scrollTo(element, to, duration) {
  if(duration <= 0) return
  let difference = to - element.scrollTop
  let perTick = difference / duration * 10

  setTimeout(function() {
    element.scrollTop = element.scrollTop + perTick
    if(element.scrollTop === to) return
    scrollTo(element, to, duration - 10)
  }, 10)
}


//////////////////////////////////////////////////////
// More ES6 kind of version with document hardcoded //
//////////////////////////////////////////////////////
const smoothScrollTo = (to, duration) => {
  if (duration <= 0) return;
  const difference = to - document.scrollTop;
  const perTick = difference / duration * 10;

  setTimeout(() => {
    document.scrollTop += perTick;
    if (document.scrollTop === to) return;
    smoothScrollTo(to, duration - 10);
  }, 10);
};

//////////////////////////////////////////////////////
// More working example from a React context        //
//////////////////////////////////////////////////////
const smoothScrollTo = (scrollingElement, to, duration) => {
  if (duration <= 0) return;
  const difference = to - scrollingElement.scrollTop;
  const perTick = (difference / duration) * 10;

  setTimeout(() => {
    // eslint-disable-next-line no-param-reassign
    scrollingElement.scrollTop += perTick;
    if (scrollingElement.scrollTop === to) return;
    smoothScrollTo(scrollingElement, to, duration - 10);
  }, 10);
};

const scrollToTop = () => {
  const scrollingElement = document.querySelector('.modal');
  smoothScrollTo(scrollingElement, 0, 500);
};
