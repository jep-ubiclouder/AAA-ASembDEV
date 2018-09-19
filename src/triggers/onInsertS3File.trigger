trigger onInsertS3File  on NEILON__File__c (after insert) {
    system.debug('hello from trigger S3');
  
}