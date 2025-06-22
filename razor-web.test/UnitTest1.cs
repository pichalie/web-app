using razor_web.Pages;

namespace razor_web.test
{
    public class UnitTest1
    {
        [Fact]
        public void canPlusNumber()
        {
            int razor = new MyCalculator().addnumber(1,1);
            Assert.Equal(2, razor);
        }
        [Fact]
        public void canMinusNumber()
        {
            int razor = new MyCalculator().minusnumber(1, 1);
            Assert.Equal(0, razor);
        }
    }
}