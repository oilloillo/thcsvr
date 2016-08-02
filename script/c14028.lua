 --Bad Apple!!
function c14028.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,14028)
	e1:SetCost(c14028.cost)
	e1:SetTarget(c14028.destg)
	e1:SetOperation(c14028.desop)
	c:RegisterEffect(e1)
end
function c14028.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c14028.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x208) and c:IsAbleToGrave()
end
function c14028.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x138) and c:IsAbleToHand()
end
function c14028.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14028.filter1,tp,LOCATION_DECK,0,1,nil) 
		or Duel.IsExistingMatchingCard(c14028.filter2,tp,LOCATION_DECK,0,1,nil) end
	local t={}
	local p=1
	if Duel.IsExistingMatchingCard(c14028.filter1,tp,LOCATION_DECK,0,1,nil) then t[p]=aux.Stringid(14028,0) p=p+1 end
	if Duel.IsExistingMatchingCard(c14028.filter2,tp,LOCATION_DECK,0,1,nil) then t[p]=aux.Stringid(14028,1) p=p+1 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(14028,2))
	local sel=Duel.SelectOption(tp,table.unpack(t))+1
	local opt=t[sel]-aux.Stringid(14028,0)
	if opt==0 then e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	else e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) end
	e:SetLabel(opt)
end
function c14028.desop(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	local sg=nil
	if opt==0 then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c14028.filter1,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoGrave(sg,REASON_EFFECT)
			Duel.Damage(tp,1000,REASON_EFFECT)
		end
	else Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c14028.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
	end
end
