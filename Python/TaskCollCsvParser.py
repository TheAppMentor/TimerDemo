import csv


class csvParser():

    def __init__(self):
        print 'Here we initializer our class'

    def writeToCSV(self, fileName, csvRow):
        with open(fileName, 'a') as outputFile:
            w = csv.writer(outputFile)
            w.writerow(csvRow)
            # w.write('\n')

    def readFromCSV(self, fileName):
        with open(fileName,'rU') as inputFile:
            reader = csv.reader(inputFile)
            for row in reader:
                print row


if __name__ == "__main__":
    parser = csvParser()
    parser.readFromCSV("/Users/i328244/Desktop/XCode Projects/TimerDemo/TimerDemo/TimerDemoTestData_Tasks.csv")