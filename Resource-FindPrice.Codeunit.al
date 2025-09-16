#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 221 "Resource-Find Price"
{
    TableNo = "Resource Price";

    trigger OnRun()
    begin
        ResPrice.Copy(Rec);
        with ResPrice do
          if FindResPrice then
            ResPrice := ResPrice2
          else begin
            Init;
            Code := Res."No.";
            "Currency Code" := '';
            "Unit Price" := Res."Unit Price";
          end;
        Rec := ResPrice;
    end;

    var
        ResPrice: Record "Resource Price";
        ResPrice2: Record "Resource Price";
        Res: Record Resource;

    local procedure FindResPrice(): Boolean
    begin
        with ResPrice do begin
          if ResPrice2.Get(Type::Resource,Code,"Work Type Code","Currency Code") then
            exit(true);

          if ResPrice2.Get(Type::Resource,Code,"Work Type Code",'') then
            exit(true);

          Res.Get(Code);
          if ResPrice2.Get(Type::"Group(Resource)",Res."Resource Group No.","Work Type Code","Currency Code") then
            exit(true);

          if ResPrice2.Get(Type::"Group(Resource)",Res."Resource Group No.","Work Type Code",'') then
            exit(true);

          if ResPrice2.Get(Type::All,'',"Work Type Code","Currency Code") then
            exit(true);

          if ResPrice2.Get(Type::All,'',"Work Type Code",'') then
            exit(true);
        end;
    end;
}

