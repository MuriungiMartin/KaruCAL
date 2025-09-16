#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50132 "HR Copy to Learning Int"
{

    trigger OnRun()
    begin
    end;

    var
        OK: Boolean;
        Employee: Record UnknownRecord61188;
        LearnInt: Record UnknownRecord61227;
        FindOK: Boolean;


    procedure CopyEduAssToLearnInt(EduAss: Record UnknownRecord61226)
    begin
        LearnInt.SetFilter(LearnInt."Employee Requisition No",EduAss."Application No");
                 if LearnInt.Find('-')  then
                 begin
                          LearnInt.Init;

                          if (EduAss.CompletedResult1 = 2) or (EduAss.CompletedResult2 = 2) or
                             (EduAss.CompletedResult3 = 2) or (EduAss.CompletedResult4 = 2) or
                             (EduAss.CompletedResult5 = 2) or (EduAss.CompletedResult5 = 2) then
                          LearnInt."Job Application No" := LearnInt."Job Application No" +
                                            EduAss."Education Credits1" +
                                            EduAss."Education Credits2" +
                                            EduAss."Education Credits3" +
                                            EduAss."Education Credits4" +
                                            EduAss."Education Credits5" +
                                            EduAss."Education Credits6";
                          LearnInt."First Name" := LearnInt."First Name" +
                                              EduAss."Training Credits1" +
                                              EduAss."Training Credits2" +
                                              EduAss."Training Credits3" +
                                              EduAss."Training Credits4" +
                                              EduAss."Training Credits5" +
                                              EduAss."Training Credits6";
                          LearnInt."Used In Education Assistance" := EduAss."Total Cost";


                      LearnInt.Insert;
                      Message(EduAss."Application No"+'has been updated in Learning Intervention.');
                 end
                 else
                 begin
                          LearnInt.Init;
                          LearnInt."Employee Requisition No" := EduAss."Application No";
                          LearnInt.Date := EduAss.Year;
                          LearnInt."Job Application No" := LearnInt."Job Application No" +
                                            EduAss."Education Credits1" +
                                            EduAss."Education Credits2" +
                                            EduAss."Education Credits3" +
                                            EduAss."Education Credits4" +
                                            EduAss."Education Credits5" +
                                            EduAss."Education Credits6";
                          LearnInt."First Name" := LearnInt."First Name" +
                                              EduAss."Training Credits1" +
                                              EduAss."Training Credits2" +
                                              EduAss."Training Credits3" +
                                              EduAss."Training Credits4" +
                                              EduAss."Training Credits5" +
                                              EduAss."Training Credits6";
                          LearnInt.Position := EduAss."Employee First Name";
                          LearnInt."Reporting Date" := EduAss."Employee Last Name";
                          LearnInt."Used In Education Assistance" := EduAss."Total Cost";


                      LearnInt.Insert;
                      Message(EduAss."Application No"+'has been created in Learning Intervention.');
                 end;
    end;
}

