#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68900 "ACA-Course Reg. Buffer"
{
    PageType = List;
    SourceTable = UnknownTable61743;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                }
                field("Reg. Trans. No.";"Reg. Trans. No.")
                {
                    ApplicationArea = Basic;
                }
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Settlement Type";"Settlement Type")
                {
                    ApplicationArea = Basic;
                }
                field("Student Type";"Student Type")
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                }
                field(Session;Session)
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Rejected;Rejected)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Reject Reason";"Reject Reason")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Post)
            {
                action(ImpCourseReg)
                {
                    ApplicationArea = Basic;
                    Caption = 'Import Course Reg. Buffer';
                    Image = ImportLog;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        if Confirm('Import course registration buffer?',true)=false then Error('Cancelled by user.');
                        cregBuffer.Reset;
                        if cregBuffer.Find('-') then cregBuffer.DeleteAll;

                        Xmlport.Run(60034,false,true);

                        Message('Imported successfully!');
                    end;
                }
                action(Post_Record)
                {
                    ApplicationArea = Basic;
                    Caption = 'Update Records';
                    Image = PostBatch;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        CorrectRegNos();
                        Clear(RecCount1);
                        Clear(RecCount2);
                        Clear(RecCount3);
                        Clear(RecCount4);
                        Clear(RecCount5);
                        Clear(RecCount6);
                        Clear(RecCount7);
                        Clear(RecCount8);
                        Clear(RecCount9);
                        Clear(RecCount10);

                        Clear(counts);
                        if Confirm('Update Records?',true)=false then Error('Cancelled by user!');
                        progre.Open('Processing Please wait..............\#1###############################################################'+
                        '\#2###############################################################'+
                        '\#3###############################################################'+
                        '\#4###############################################################'+
                        '\#5###############################################################'+
                        '\#6###############################################################'+
                        '\#7###############################################################'+
                        '\#8###############################################################'+
                        '\#9###############################################################'+
                        '\#10###############################################################'+
                        '\#11###############################################################'+
                        '\#12###############################################################'+
                        '\#13###############################################################',
                            RecCount1,
                            RecCount2,
                            RecCount3,
                            RecCount4,
                            RecCount5,
                            RecCount6,
                            RecCount7,
                            RecCount8,
                            RecCount9,
                            RecCount10,
                            Var1,
                            Var1,
                            BufferString
                        );
                        cregBuffer.Reset;
                        Clear(Var1);
                        //cregBuffer.SETRANGE(cregBuffer.Posted,FALSE);
                        if cregBuffer.Find('-') then begin
                          repeat
                            begin
                            counts:=counts+1;
                            if counts=1 then
                            RecCount1:=Format(counts)+'). '+cregBuffer."Student No."+': '+cregBuffer."Student Name"
                            else if counts=2 then begin
                            RecCount2:=Format(counts)+'). '+cregBuffer."Student No."+': '+cregBuffer."Student Name"
                            end
                            else if counts=3 then begin
                            RecCount3:=Format(counts)+'). '+cregBuffer."Student No."+': '+cregBuffer."Student Name"
                            end
                            else if counts=4 then begin
                            RecCount4:=Format(counts)+'). '+cregBuffer."Student No."+': '+cregBuffer."Student Name"
                            end
                            else if counts=5 then begin
                            RecCount5:=Format(counts)+'). '+cregBuffer."Student No."+': '+cregBuffer."Student Name"
                            end
                            else if counts=6 then begin
                            RecCount6:=Format(counts)+'). '+cregBuffer."Student No."+': '+cregBuffer."Student Name"
                            end
                            else if counts=7 then begin
                            RecCount7:=Format(counts)+'). '+cregBuffer."Student No."+': '+cregBuffer."Student Name"
                            end
                            else if counts=8 then begin
                            RecCount8:=Format(counts)+'). '+cregBuffer."Student No."+': '+cregBuffer."Student Name"
                            end
                            else if counts=9 then begin
                            RecCount9:=Format(counts)+'). '+cregBuffer."Student No."+': '+cregBuffer."Student Name"
                            end
                            else if counts=10 then begin
                            RecCount10:=Format(counts)+'). '+cregBuffer."Student No."+': '+cregBuffer."Student Name"
                            end else if counts>10 then begin
                            RecCount1:=RecCount2;
                            RecCount2:=RecCount3;
                            RecCount3:=RecCount4;
                            RecCount4:=RecCount5;
                            RecCount5:=RecCount6;
                            RecCount6:=RecCount7;
                            RecCount7:=RecCount8;
                            RecCount8:=RecCount9;
                            RecCount9:=RecCount10;
                            RecCount10:=Format(counts)+'). '+cregBuffer."Student No."+': '+cregBuffer."Student Name";
                            end;
                            Clear(BufferString);
                            BufferString:='Total Records processed = '+Format(counts);

                            progre.Update();
                            Sleep(25);
                            cust.Reset;
                            cust.SetRange(cust."No.",cregBuffer."Student No.");
                            if not cust.Find('-') then begin
                              cregBuffer.Posted:=false;
                              cregBuffer.Rejected:=true;
                              cregBuffer."Reject Reason":='Student No. '+cregBuffer."Student No."+' Does not exist.';
                              cregBuffer.Modify;
                            end else begin
                              creg.Reset;
                              creg.SetRange(creg."Student No.",cregBuffer."Student No.");
                              creg.SetRange(creg.Programme,cregBuffer.Programme);
                              creg.SetRange(creg.Semester,cregBuffer.Semester);
                              //creg.SETRANGE(creg.Stage,cregBuffer.Stage);
                              creg.SetRange(creg."Academic Year",cregBuffer."Academic Year");
                              if not creg.Find('-') then begin
                              creg.Init;
                              creg."Reg. Transacton ID":=cregBuffer."Reg. Trans. No.";
                              creg."Student No.":=cregBuffer."Student No.";
                                    if Evaluate(openDate,'10032016') then
                              creg."Registration Date":=openDate;
                              creg.Programme:=cregBuffer.Programme;
                              creg.Semester:=cregBuffer.Semester;
                              creg."Register for":=creg."register for"::Stage;
                              creg.Stage:=cregBuffer.Stage;
                              creg."Student Type":=creg."student type"::"Full Time";
                              creg."Settlement Type":=cregBuffer."Settlement Type";
                              creg.Validate(creg."Registration Date");
                              creg.Validate(creg."Settlement Type");
                              creg."Academic Year":=cregBuffer."Academic Year";
                              creg.Insert;
                              cregBuffer.Posted:=true;
                              cregBuffer.Rejected:=false;
                              cregBuffer."Reject Reason":='';
                              cregBuffer.Modify;
                              end else begin
                              cregBuffer.Posted:=false;
                              cregBuffer.Rejected:=true;
                              cregBuffer."Reject Reason":='Already Registered!!';
                              cregBuffer.Modify;
                              end;
                            end;
                            end;
                          until cregBuffer.Next = 0;
                        end;
                            progre.Close;

                        Message('Done!');
                        CurrPage.Update;
                    end;
                }
            }
        }
    }

    var
        creg: Record UnknownRecord61532;
        cregBuffer: Record UnknownRecord61743;
        RejReason: Text;
        cust: Record Customer;
        progre: Dialog;
        counts: Integer;
        RecCount1: Text[120];
        RecCount2: Text[120];
        RecCount3: Text[120];
        RecCount4: Text[120];
        RecCount5: Text[120];
        RecCount6: Text[120];
        RecCount7: Text[120];
        RecCount8: Text[120];
        RecCount9: Text[120];
        RecCount10: Text[120];
        BufferString: Text[1024];
        Var1: Code[10];
        openDate: Date;


    procedure CorrectRegNos()
    var
        cust1: Record Customer;
        custBuff: Record UnknownRecord61743;
        replace: Text[100];
        replacewith: Text[100];
        No_Stem: Text[100];
        New_No: Text[100];
        removedString: Text[100];
        counted: Integer;
        NewStem: Text[100];
        stringChar: Code[1];
    begin
          /* // STEP 1: Remove the first stroke
        IF CONFIRM('Update Records?',TRUE)=FALSE THEN ERROR('Cancelled by user!');
        
           custBuff.RESET;
           custBuff.SETFILTER(custBuff."Student No.",'<>%1','');
           IF custBuff.FIND('-') THEN BEGIN
           REPEAT
           BEGIN
           // Clear Variables Here
           IF STRLEN(custBuff."Student No.")>5 THEN BEGIN
           CLEAR(No_Stem);
           CLEAR(removedString);
           IF NOT cust1.GET(custBuff."Student No.") THEN BEGIN
              IF (COPYSTR(custBuff."Student No.",(STRLEN(custBuff."Student No.")-2),1))='/' THEN BEGIN
              //
               No_Stem:=COPYSTR(custBuff."Student No.",1,(STRLEN(custBuff."Student No.")-3));
               removedString:=COPYSTR(custBuff."Student No.",(STRLEN(custBuff."Student No.")-2),3);
              END// if /13
              ELSE IF  (COPYSTR(custBuff."Student No.",(STRLEN(custBuff."Student No.")-4),1))='/' THEN BEGIN
              //
               No_Stem:=COPYSTR(custBuff."Student No.",1,(STRLEN(custBuff."Student No.")-5));
               removedString:=COPYSTR(custBuff."Student No.",(STRLEN(custBuff."Student No.")-4),5);
              END;// if /2013
              IF No_Stem<>'' THEN BEGIN
            // create a new stem
            CLEAR(counted);
            CLEAR(NewStem);
            REPEAT
              BEGIN
              CLEAR(stringChar);
               counted:=counted+1;
               stringChar:=COPYSTR(No_Stem,counted,1);
               IF ((stringChar='/') OR (stringChar='\')) THEN
                stringChar:='-';
               NewStem:=NewStem+stringChar;
              END;
            UNTIL ((counted = STRLEN(No_Stem)) OR (counted > STRLEN(No_Stem)));
            END; // if No_Stem<>''
            // Modify the student No now
            IF NewStem<>'' THEN BEGIN
               No_Stem:=NewStem;
               No_Stem:=No_Stem+removedString;
               custBuff."Student No.":=No_Stem;
               custBuff.MODIFY;
              //custBuff.RENAME(custBuff.Programme,No_Stem,custBuff."Academic Year",custBuff.Semester,custBuff."Reg. Trans. No.");
            END;// if NewStem<>''
           END;// if not in the student list
           END;// for repeat
           END;
           UNTIL custBuff.NEXT=0;
           END;
        
        
           // STEP 2: Check & Modify Year from eg. /13 to 2013 and back to /13 for legnth >21
            progre.OPEN('progress......\#1####################################################################################');
           custBuff.RESET;
          custBuff.SETFILTER(custBuff."Student No.",'<>%1','');
           IF custBuff.FIND('-') THEN BEGIN
           REPEAT
           BEGIN
           // Clear Variables Here
           CLEAR(No_Stem);
           CLEAR(replace);
           CLEAR(replacewith);
           CLEAR(New_No);
           IF NOT cust1.GET(custBuff."Student No.") THEN BEGIN
          // ERROR((COPYSTR(custBuff."Student No.",((STRLEN(custBuff."Student No."))-2),1)));
              IF (COPYSTR(custBuff."Student No.",((STRLEN(custBuff."Student No."))-2),1))='/' THEN BEGIN
                IF (((STRLEN(custBuff."Student No."))<19) AND ((STRLEN(custBuff."Student No."))>5)) THEN BEGIN
                  // Change Year part format
                 replace:=COPYSTR(custBuff."Student No.",(STRLEN(custBuff."Student No.")-2),3);
                 replacewith:='/20'+COPYSTR(custBuff."Student No.",(STRLEN(custBuff."Student No.")-1),2);
                 No_Stem:=COPYSTR(custBuff."Student No.",1,(STRLEN(custBuff."Student No.")-3));
                 New_No:=No_Stem+replacewith;
                 progre.UPDATE(1,custBuff."Student No."+','+replace+','+replacewith+','+No_Stem+','+New_No);
               //  ERROR(custBuff."Student No."+',"+replace+','+replacewith+','+No_Stem+','+New_No);
        
               custBuff."Student No.":=New_No;
               custBuff.MODIFY;
             // custBuff.RENAME(custBuff.Programme,New_No,custBuff."Academic Year",custBuff.Semester,custBuff."Reg. Trans. No.");
                END; //STRLEN(custBuff."Student No.")<19
              END;// if /13
           END;// Not in the customer List
           END;// Repeat in CustBuff
           UNTIL custBuff.NEXT=0;
           END;// custBuff.find('-')
          progre.CLOSE;
        MESSAGE('Data edited Successfully.');*/

    end;
}

