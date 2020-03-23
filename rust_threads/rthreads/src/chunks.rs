use std::ops::Range;

pub trait Chunkable {
    // splits a Range into a vector of ranges at least of length chunk_size
    fn chunks(&self, chunk_size: usize) -> Vec<Range<usize>>;

    // divide a range into a vector of a maximum of n sub-ranges
    fn split_into(&self, n: usize) -> Vec<Range<usize>>;
}

impl Chunkable for Range<usize> {
    fn chunks(&self, chunk_size: usize) -> Vec<Range<usize>> {
        // non-sense for a zero sized chunk
        assert!(chunk_size != 0);

        // create a vector from range containing all ranges
        // as the collect will contain refs, need to clone
        let tmp: Vec<_> = self.clone().collect();

        // empty vector will contain our ranges
        let mut v = Vec::new();

        // as we have now a vector, we can use the chunks() slice method
        // chunks will contain a vector a vectors
        let chunks = tmp.chunks(chunk_size);

        // convert each individual chunk into a range
        for chunk in chunks {
            v.push(chunk[0]..*chunk.last().unwrap() + 1);
        }

        v
    }

    fn split_into(&self, n: usize) -> Vec<Range<usize>> {
        self.chunks(self.len() / n)
    }
}

#[cfg(test)]
mod tests {

    use super::Chunkable;

    #[test]
    fn test_chunks() {
        assert_eq!((0..10).chunks(5), vec![0..5, 5..10]);
        assert_eq!((0..11).chunks(5), vec![0..5, 5..10, 10..11]);
    }

    #[test]
    fn test_split_into() {
        assert_eq!((0..10).split_into(2), vec![0..5, 5..10]);
        assert_eq!((0..10).split_into(3), vec![0..3, 3..6, 6..9, 9..10]);
    }

}
