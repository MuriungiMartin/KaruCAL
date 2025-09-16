#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 63900 UpdateNames
{

    trigger OnRun()
    var
        progrezz: Dialog;
    begin
        Customer.Reset;
        Customer.SetRange("Customer Posting Group",'STUDENT');
        Customer.SetFilter(Name,'<>%1',' ');
        if Customer.Find('-') then begin
          Clear(totalCounts);
          totalCounts:=Customer.Count;
          Clear(Counted);
          Clear(CountsRemaining);
          progrezz.Open('Total: #1########################################################\'+
          'Counted: #2########################################################'+
          'Remaining: #3########################################################'+
          '\');
          repeat
            begin
          ///////////////////////////////////////////////////////////////////

        Clear(SecondSpacePos);
        Clear(FirstSpacePos);
        if Customer.Name<>'' then begin
        //  Fnames:=ReturnName(Customer.Name,RetVals::FirstName);
        //  MNames:=ReturnName(Customer.Name,RetVals::MiddleName);
        //  LNames:=ReturnName(Customer.Name,RetVals::LastName);
        Clear(FirstName);
        Clear(MiddleName);
        Clear(LastName);
        Clear(LoopCounts);
        Clear(NoOfSpaces);
          LoopCounts:=1;
        repeat
          begin
          Clear(incrementChar);
          Clear(StringChar);
          StringChar:=CopyStr(Customer.Name,LoopCounts,1);
          if (StringChar=' ') then begin
          incrementChar:=0;
          NoOfSpaces:=NoOfSpaces+1;
          if NoOfSpaces=1 then FirstSpacePos:=LoopCounts;
          if NoOfSpaces=2 then SecondSpacePos:=LoopCounts;
             if (CopyStr(Customer.Name,(LoopCounts+1),1)='') then incrementChar:=1;
             if (CopyStr(Customer.Name,(LoopCounts+2),1)='') then incrementChar:=2;
             if (CopyStr(Customer.Name,(LoopCounts+3),1)='') then incrementChar:=3;
             LoopCounts:=LoopCounts+incrementChar;

          end;
          LoopCounts:=LoopCounts+1;
          end;
            until ((LoopCounts=(StrLen(Customer.Name))) or (NoOfSpaces=2) or (LoopCounts>(StrLen(Customer.Name))));
        if (FirstSpacePos<StrLen(Customer.Name)) then
        FirstName:=CopyStr(Customer.Name,1,FirstSpacePos)
        else FirstName:=Customer.Name;

        if SecondSpacePos<>0 then
          if FirstSpacePos<>0 then
        MiddleName:=CopyStr(Customer.Name,FirstSpacePos,SecondSpacePos-FirstSpacePos);

        if SecondSpacePos=0 then begin
            if (StrLen(Customer.Name)>FirstSpacePos+1) then begin
        MiddleName:=CopyStr(Customer.Name,(FirstSpacePos+1),((StrLen(Customer.Name)-FirstSpacePos)+1));
              end;
          end;

        if (StrLen(Customer.Name)-SecondSpacePos)>0 then
          if SecondSpacePos<>0 then
        LastName:=CopyStr(Customer.Name,SecondSpacePos,((StrLen(Customer.Name)-SecondSpacePos)+1));
          StudNames.Reset;
          StudNames.SetRange("Student No.",Customer."No.");
          if StudNames.Find('-') then begin
            StudNames."F. Name":=FirstName;
            StudNames."M. Name":=MiddleName;
            StudNames."L Name":=LastName;
            StudNames.Modify;
            end else begin
            StudNames."Student No.":=Customer."No.";
            StudNames."F. Name":=FirstName;
            StudNames."M. Name":=MiddleName;
            StudNames."L Name":=LastName;
            StudNames.Insert;
              end;
        // "First Name":=FirstName;
        //
        // "Middle Name":=MiddleName;
        //
        // "Last Name":=LastName;
        end;
          ///////////////////////////////////////////////////////////////////////(Name);
            Counted:=Counted+1;
            if Counted=267 then
              Counted:=Counted;
            CountsRemaining:=totalCounts-Counted;
          //  Customer.MODIFY;
          progrezz.Update(1,Format('Total: '+Format(totalCounts)));
          progrezz.Update(2,Format('Counts: '+Format(Counted)));
          progrezz.Update(3,Format('Renaining:'+Format(CountsRemaining)));
            end;
            until Customer.Next=0;
          progrezz.Close;
          end;
    end;

    var
        Customer: Record Customer;
        totalCounts: Integer;
        Counted: Integer;
        CountsRemaining: Integer;
        NoOfSpaces: Integer;
        FullStringLegnth: Integer;
        FirstName: Text[150];
        MiddleName: Text[150];
        LastName: Text[150];
        LoopCounts: Integer;
        FirstSpacePos: Integer;
        SecondSpacePos: Integer;
        incrementChar: Integer;
        StringChar: Text[1];
        StudNames: Record UnknownRecord63906;
}

