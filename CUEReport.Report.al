#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 63905 "CUE Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CUE Report.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = where("Customer Posting Group"=filter('STUDENT'));
            RequestFilterFields = "No.";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(IDNo;Customer."ID No")
            {
            }
            column(No;Customer."No.")
            {
            }
            column(Names;Customer.Name)
            {
            }
            column(FirstNames;Fnames)
            {
            }
            column(MiddleNames;MNames)
            {
            }
            column(LastNames;LNames)
            {
            }
            column(Addr;Customer.Address)
            {
            }
            column(Addre2;Customer."Address 2")
            {
            }
            column(PhoneNo;Customer."Phone No.")
            {
            }
            column(Gender;Customer.Gender)
            {
            }
            column(DoB;Customer."Date Of Birth")
            {
            }
            column(YoS;StudyYear)
            {
            }
            column(Country;Customer."Country/Region Code")
            {
            }
            column(County;Customer.County)
            {
            }
            column(Tribe;Customer.Tribe)
            {
            }
            column(ProGCode;Coregs.Programme)
            {
            }
            column(AdmissionDate;Coregs2."Registration Date")
            {
            }
            column(Campus;Customer."Global Dimension 1 Code")
            {
            }
            column(seq;seq)
            {
            }

            trigger OnAfterGetRecord()
            var
                NoOfSpaces: Integer;
                FullStringLegnth: Integer;
                FirstName: Text[150];
                MiddleName: Text[150];
                LastName: Text[150];
                LoopCounts: Integer;
                FirstSpacePos: Integer;
                SecondSpacePos: Integer;
                incrementChar: Integer;
            begin
                  Clear(Fnames);
                  Clear(MNames);
                  Clear(LNames);
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

                  Fnames:=FirstName;

                  MNames:=MiddleName;

                  LNames:=LastName;
                end;
                Coregs.Reset;
                Coregs.SetRange("Student No.",Customer."No.");
                Coregs.SetRange(Reversed,false);
                if Coregs.Find('+') then;
                Clear(StudyYear);
                if StrLen(Coregs.Stage)>1 then StudyYear:=CopyStr(Coregs.Stage,2,1);

                Coregs2.Reset;
                Coregs2.SetRange("Student No.",Customer."No.");
                Coregs2.SetRange(Reversed,false);
                if Coregs2.Find('-') then;
                seq:=seq+1;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Fnames: Text[100];
        MNames: Text[100];
        LNames: Text[100];
        StringChar: Text[1];
        RetVals: Option FirstName,MiddleName,LastName;
        Coregs: Record UnknownRecord61532;
        Coregs2: Record UnknownRecord61532;
        StudyYear: Text;
        seq: Integer;

    local procedure ReturnName(FullNames: Text[250];ReturnType: Option FirstName,MiddleName,LastName) NameReturned: Text[150]
    var
        NoOfSpaces: Integer;
        FullStringLegnth: Integer;
        FirstName: Text[150];
        MiddleName: Text[150];
        LastName: Text[150];
        LoopCounts: Integer;
        FirstSpacePos: Integer;
        SecondSpacePos: Integer;
        incrementChar: Integer;
    begin
        Clear(FirstName);
        Clear(NameReturned);
        Clear(MiddleName);
        Clear(LastName);
        Clear(LoopCounts);
        Clear(NoOfSpaces);
          LoopCounts:=1;
        repeat
          begin
          Clear(incrementChar);
          Clear(StringChar);
          StringChar:=CopyStr(FullNames,LoopCounts,1);
          if (StringChar=' ') then begin
          incrementChar:=0;
          NoOfSpaces:=NoOfSpaces+1;
          if NoOfSpaces=1 then FirstSpacePos:=LoopCounts;
          if NoOfSpaces=2 then SecondSpacePos:=LoopCounts;
             if (CopyStr(FullNames,(LoopCounts+1),1)='') then incrementChar:=1;
             if (CopyStr(FullNames,(LoopCounts+2),1)='') then incrementChar:=2;
             if (CopyStr(FullNames,(LoopCounts+3),1)='') then incrementChar:=3;
             LoopCounts:=LoopCounts+incrementChar;

          end;
          LoopCounts:=LoopCounts+1;
          end;
           until ((LoopCounts=(StrLen(Customer.Name))) or (NoOfSpaces=2) or (LoopCounts>(StrLen(Customer.Name))));
        if (FirstSpacePos<StrLen(FullNames)) then
        FirstName:=CopyStr(FullNames,1,FirstSpacePos)
        else FirstName:=FullNames;

        if SecondSpacePos<>0 then
          if FirstSpacePos<>0 then
        MiddleName:=CopyStr(FullNames,FirstSpacePos,SecondSpacePos-FirstSpacePos);

        if SecondSpacePos=0 then begin
            if (StrLen(FullNames)>FirstSpacePos+1) then begin
        MiddleName:=CopyStr(FullNames,(FirstSpacePos+1),((StrLen(FullNames)-FirstSpacePos)+1));
              end;
          end;

        if (StrLen(FullNames)-SecondSpacePos)>0 then
          if SecondSpacePos<>0 then
        LastName:=CopyStr(FullNames,SecondSpacePos,((StrLen(FullNames)-SecondSpacePos)+1));
        if ReturnType=Returntype::FirstName then
        NameReturned:=FirstName;
        if ReturnType=Returntype::MiddleName then
        NameReturned:=MiddleName;
        if ReturnType=Returntype::LastName then
        NameReturned:=LastName;
    end;
}

