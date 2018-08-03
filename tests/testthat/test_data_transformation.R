context("Load and Transform Data")

#Load in pre-parsed example data as a baseline
data(example_data)

#Parse from a raw csv
data_path = system.file("extdata", package = 'clustershard')

data1 = paste0(data_path,'/pottery_dat.csv')
data2 = paste0(data_path,'/data_messy.csv')
data3 = paste0(data_path,'/data_fail.csv')
data4 = paste0(data_path,'/data_test.csv')
parsed_data = processPotteryDat(data1)


test_that("Error handling", {
  expect_error( processPotteryDat(data_path,
    element_start_column = 1))

  expect_error( processPotteryDat(dat3))

  expect_error( processPotteryDat(data4))

  expect_error( processPotteryDat(data4, #No error
                                  element_start_column = 5),
                NA)
})


test_that("Outputs expected data", {
  expect_equal( example_data, parsed_data)
})



