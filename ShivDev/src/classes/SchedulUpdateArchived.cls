global class SchedulUpdateArchived implements Schedulable{
    public void execute(SchedulableContext SC){
        BatchUpdateArchived batch = new BatchUpdateArchived();
        DataBase.executeBatch(batch);
    }
}