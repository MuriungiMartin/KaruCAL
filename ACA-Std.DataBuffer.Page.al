#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68929 "ACA-Std. Data Buffer"
{
    PageType = List;
    SourceTable = UnknownTable61747;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Counts;Counts)
                {
                    ApplicationArea = Basic;
                }
                field("Stud. No.";"Stud. No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field(ID;ID)
                {
                    ApplicationArea = Basic;
                }
                field(Campus;Campus)
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field(Phone;Phone)
                {
                    ApplicationArea = Basic;
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                }
                field(Updated;Updated)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(DOB;DOB)
                {
                    ApplicationArea = Basic;
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic;
                }
                field(County;County)
                {
                    ApplicationArea = Basic;
                }
                field(School;School)
                {
                    ApplicationArea = Basic;
                }
                field(Grade;Grade)
                {
                    ApplicationArea = Basic;
                }
                field("Guardian Name";"Guardian Name")
                {
                    ApplicationArea = Basic;
                }
                field("Guardian Contact";"Guardian Contact")
                {
                    ApplicationArea = Basic;
                }
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                }
                field("Admission Date";"Admission Date")
                {
                    ApplicationArea = Basic;
                }
                field("Courese Duration";"Courese Duration")
                {
                    ApplicationArea = Basic;
                }
                field("Study Mode";"Study Mode")
                {
                    ApplicationArea = Basic;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                }
                field(Sponsor;Sponsor)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(imports)
            {
                ApplicationArea = Basic;
                Caption = 'Import Student Data';
                Image = ImportCodes;
                Promoted = true;

                trigger OnAction()
                begin
                     if Confirm('Import student records?...', false)=false then  exit;
                    Xmlport.Run(50803, false, true);
                end;
            }
            action(posts)
            {
                ApplicationArea = Basic;
                Caption = 'Post/Update Data';
                Image = UpdateDescription;
                Promoted = true;

                trigger OnAction()
                begin
                    if Confirm('Update Students Data',true)=false then Error('Cancelled by user..');
                    CorrectRegNos();
                    pross.Open('Processing.....\No: #1#####################');
                    studDataBuff.Reset;
                    studDataBuff.SetRange(studDataBuff.Updated,false);
                    if studDataBuff.Find('-') then begin
                      repeat
                         pross.Update(1,studDataBuff."Stud. No."+': '+studDataBuff.Name);
                         Sleep(25);
                         cust.Reset;
                        if cust.Get(studDataBuff."Stud. No.") then begin
                           cust.Name:=studDataBuff.Name;
                           cust."Search Name" :=studDataBuff.Name;
                           cust.Address:=studDataBuff.Address;
                           cust."Address 2":=studDataBuff."Address 2";
                           cust.City:=studDataBuff."Address 2";
                           if StrLen(studDataBuff.Phone)>30 then
                           cust."Phone No.":=CopyStr(studDataBuff.Phone,1,30);
                           cust."Global Dimension 1 Code" :=studDataBuff.Campus;
                           if studDataBuff.Gender='Male' then
                           cust.Gender:=2 else cust.Gender:=3;
                           cust."ID No":=studDataBuff.ID;
                          // cust."Date Of Birth":=studDataBuff.DOB;
                           cust."E-Mail":=studDataBuff.Email;
                           cust.County:=studDataBuff.County;
                           cust."Sponsor Name":=studDataBuff.Sponsor;
                           cust.School:=studDataBuff.School;
                          // cust."Study Mode":=studDataBuff."Study Mode";
                          // cust."Course Duration":=studDataBuff."Courese Duration";
                          // cust."Admission Date":=studDataBuff."Admission Date";
                           cust."Global Dimension 2 Filter":=studDataBuff.Department;
                           cust."Current Programme":=studDataBuff.Programme;
                           cust."Current Program":=studDataBuff.Programme;
                           cust.Modify;
                        studDataBuff.Updated:=true;
                        studDataBuff.Modify;
                        end else begin
                          // Insert the record if Missing
                           cust.Init;
                           cust."No.":=studDataBuff."Stud. No.";
                           cust.Name:=studDataBuff.Name;
                           cust."Search Name" :=studDataBuff.Name;
                           cust.Address:=studDataBuff.Address;
                           cust."Address 2":=studDataBuff."Address 2";
                           cust.City:=studDataBuff."Address 2";
                           if StrLen(studDataBuff.Phone)>30 then
                           cust."Phone No.":=CopyStr(studDataBuff.Phone,1,30);
                           cust."Global Dimension 1 Code" :=studDataBuff.Campus;
                           if studDataBuff.Gender='Male' then
                           cust.Gender:=2 else cust.Gender:=3;
                           cust."ID No":=studDataBuff.ID;
                           cust."Customer Type":=cust."customer type"::Student;
                           cust."Customer Posting Group":='STUDENT';
                          // cust."Date Of Birth":=studDataBuff.DOB;
                           cust."E-Mail":=studDataBuff.Email;
                           cust.County:=studDataBuff.County;
                           cust."Sponsor Name":=studDataBuff.Sponsor;
                           cust.School:=studDataBuff.School;
                          // cust."Study Mode":=studDataBuff."Study Mode";
                          // cust."Course Duration":=studDataBuff."Courese Duration";
                          // cust."Admission Date":=studDataBuff."Admission Date";
                           cust."Global Dimension 2 Filter":=studDataBuff.Department;
                           cust."Current Programme":=studDataBuff.Programme;
                           cust."Current Program":=studDataBuff.Programme;
                           cust.Insert(true);
                        studDataBuff.Updated:=false;
                        studDataBuff.Modify;
                        end;
                      until studDataBuff.Next =0;
                    end else
                     begin pross.Close;
                     Error('There are no records to be updated...');
                    end;
                    pross.Close;
                    CurrPage.Update(true);
                    Message('Updated Successfully!');
                end;
            }
        }
    }

    var
        studDataBuff: Record UnknownRecord61747;
        cust: Record Customer;
        pross: Dialog;


    procedure CorrectRegNos()
    var
        cust1: Record Customer;
        custBuff: Record UnknownRecord61747;
        replace: Text[100];
        replacewith: Text[100];
        No_Stem: Text[100];
        New_No: Text[100];
        removedString: Text[100];
        counted: Integer;
        NewStem: Text[100];
        stringChar: Code[1];
    begin
           // STEP 1: Remove the first stroke
        if Confirm('Update Records?',true)=false then Error('Cancelled by user!');

           custBuff.Reset;
           custBuff.SetFilter(custBuff."Stud. No.",'<>%1','');
           if custBuff.Find('-') then begin
           repeat
           if not (CopyStr(custBuff."Stud. No.",1,6)='REGIST') then
           begin
           // Clear Variables Here
           if StrLen(custBuff."Stud. No.")>5 then begin
           Clear(No_Stem);
           Clear(removedString);
           if not cust1.Get(custBuff."Stud. No.") then begin
              if (CopyStr(custBuff."Stud. No.",(StrLen(custBuff."Stud. No.")-2),1))='/' then begin
              //
               No_Stem:=CopyStr(custBuff."Stud. No.",1,(StrLen(custBuff."Stud. No.")-3));
               removedString:=CopyStr(custBuff."Stud. No.",(StrLen(custBuff."Stud. No.")-2),3);
              end// if /13
              else if  (CopyStr(custBuff."Stud. No.",(StrLen(custBuff."Stud. No.")-4),1))='/' then begin
              //
               No_Stem:=CopyStr(custBuff."Stud. No.",1,(StrLen(custBuff."Stud. No.")-5));
               removedString:=CopyStr(custBuff."Stud. No.",(StrLen(custBuff."Stud. No.")-4),5);
              end;// if /2013
              if No_Stem<>'' then begin
            // create a new stem
            Clear(counted);
            Clear(NewStem);
            repeat
              begin
              Clear(stringChar);
               counted:=counted+1;
               stringChar:=CopyStr(No_Stem,counted,1);
               if ((stringChar='/') or (stringChar='\')) then
                stringChar:='-';
               NewStem:=NewStem+stringChar;
              end;
            until ((counted = StrLen(No_Stem)) or (counted > StrLen(No_Stem)));
            end; // if No_Stem<>''
            // Modify the student No now
            if NewStem<>'' then begin
               No_Stem:=NewStem;
               No_Stem:=No_Stem+removedString;
               custBuff."Stud. No.":=No_Stem;
               custBuff.Modify;
              //custBuff.RENAME(custBuff.Programme,No_Stem,custBuff."Academic Year",custBuff.Semester,custBuff."Reg. Trans. No.");
            end;// if NewStem<>''
           end;// if not in the student list
           end;// for repeat
           end;
           until custBuff.Next=0;
           end;


           // STEP 2: Check & Modify Year from eg. /13 to 2013 and back to /13 for legnth >21
            //progre.OPEN('progress......\#1####################################################################################');
           custBuff.Reset;
          custBuff.SetFilter(custBuff."Stud. No.",'<>%1','');
           if custBuff.Find('-') then begin
           repeat
              if not (CopyStr(custBuff."Stud. No.",1,6)='REGIST') then
           begin
           // Clear Variables Here
           Clear(No_Stem);
           Clear(replace);
           Clear(replacewith);
           Clear(New_No);
           if not cust1.Get(custBuff."Stud. No.") then begin
          // ERROR((COPYSTR(custBuff."Stud. No.",((STRLEN(custBuff."Stud. No."))-2),1)));
              if (CopyStr(custBuff."Stud. No.",((StrLen(custBuff."Stud. No."))-2),1))='/' then begin
                if (((StrLen(custBuff."Stud. No."))<19) and ((StrLen(custBuff."Stud. No."))>5)) then begin
                  // Change Year part format
                 replace:=CopyStr(custBuff."Stud. No.",(StrLen(custBuff."Stud. No.")-2),3);
                 replacewith:='/20'+CopyStr(custBuff."Stud. No.",(StrLen(custBuff."Stud. No.")-1),2);
                 No_Stem:=CopyStr(custBuff."Stud. No.",1,(StrLen(custBuff."Stud. No.")-3));
                 New_No:=No_Stem+replacewith;
                 //progre.UPDATE(1,custBuff."Stud. No."+','+replace+','+replacewith+','+No_Stem+','+New_No);
               //  ERROR(custBuff."Stud. No."+',"+replace+','+replacewith+','+No_Stem+','+New_No);
                 custBuff."Stud. No.":=New_No;
                 custBuff.Modify;
             // custBuff.RENAME(custBuff.Programme,New_No,custBuff."Academic Year",custBuff.Semester,custBuff."Reg. Trans. No.");
                end; //STRLEN(custBuff."Stud. No.")<19
              end;// if /13
           end;// Not in the customer List
           end;// Repeat in CustBuff
           until custBuff.Next=0;
           end;// custBuff.find('-')
          //progre.CLOSE;
        Message('Data edited Successfully.');
    end;
}

