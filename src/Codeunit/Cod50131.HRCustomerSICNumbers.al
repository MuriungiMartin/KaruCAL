#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50131 "HR Customer SIC Numbers"
{

    trigger OnRun()
    begin
    end;

    var
        SICNumbers: Record UnknownRecord61235;
        CustSICNumbers: Record UnknownRecord61249;
        Found: Boolean;
        OK: Boolean;


    procedure GetSICNumbers(CustNo: Code[10];sic: Integer)
    begin
                 Found := SICNumbers.Find('-');
                 case sic of
                  1 : begin
                   OK := FindCustomer(CustNo);
                   if ((Found) and (not OK)) then begin

                    repeat
                      CustSICNumbers.Init;
                      CustSICNumbers."Training Code":= CustNo;
                      CustSICNumbers."Employee Code":= SICNumbers."SIC Code Level 4";
                      CustSICNumbers."Employee name":= SICNumbers."Employee No";
                      CustSICNumbers.Objectives:= SICNumbers."Evaluation Code";
                      CustSICNumbers."Section Description":= SICNumbers."Evaluation Description";
                      CustSICNumbers.Insert;

                    until SICNumbers.Next = 0;
                  end;
                 end;
                 2: begin

                    repeat
                      CustSICNumbers.Init;
                      CustSICNumbers."Training Code":= CustNo;
                      CustSICNumbers."Employee Code":= SICNumbers."SIC Code Level 4";
                      CustSICNumbers."Employee name":= SICNumbers."Employee No";
                      CustSICNumbers.Objectives:= SICNumbers."Evaluation Code";
                      CustSICNumbers."Section Description":= SICNumbers."Evaluation Description";
                      CustSICNumbers.Insert;

                    until SICNumbers.Next = 0;
                   end;
                 end;
    end;


    procedure FindCustomer(CustNo: Code[10]) FoundEmp: Boolean
    var
        CustomerNumber: Code[20];
    begin
                  Found:= CustSICNumbers.Find('-');

                   if (Found) then begin
                   while ((FoundEmp = false) and (CustSICNumbers.Next <> 0)) do begin
                       CustomerNumber:= CustSICNumbers."Training Code";
                        if (CustomerNumber = CustNo) then begin
                          FoundEmp:= true
                        end else FoundEmp:= false;
                        CustSICNumbers.Next;
                    end;
                   end;
    end;


    procedure DeleteSICNumbers(CustNo: Code[10])
    begin
                    CustSICNumbers.SetRange("Training Code",CustNo);
                    CustSICNumbers.DeleteAll;
    end;
}

