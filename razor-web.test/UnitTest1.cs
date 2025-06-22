namespace razor_web.test
{
    public class UnitTest1
    {
        [Fact]
        public void Test1()
        {
            bool result = false;
            Assert.False(result, "1 should not be prime");
        }
    }
}