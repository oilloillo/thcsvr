--生命的二刀流✿魂魄妖梦
function c20028.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x208),1)
	c:EnableReviveLimit()
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20028,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c20028.descon)
	e1:SetTarget(c20028.target)
	e1:SetOperation(c20028.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20028,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_EQUIP)
	e2:SetTarget(c20028.destg)
	e2:SetOperation(c20028.desop)
	c:RegisterEffect(e2)
end
function c20028.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c20028.tgfilter(c)
	return c:IsSetCard(0x201) and c:IsAbleToGrave()
end
function c20028.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20028.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c20028.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c20028.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
			Duel.SetLP(tp,6000)
		end
	end
end
function c20028.filter(c,ec)
	return c:IsSetCard(0x201) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c20028.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroupCount(c20028.filter,tp,LOCATION_DECK,0,nil,e:GetHandler())
	local g2=Duel.GetMatchingGroupCount(c20028.filter,tp,LOCATION_GRAVE,0,nil,e:GetHandler())
	if chk==0 then return (g1>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or (g2>1 and Duel.GetLocationCount(tp,LOCATION_SZONE)>1) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c20028.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local c1=Duel.IsExistingMatchingCard(c20028.filter,tp,LOCATION_DECK,0,1,nil,e:GetHandler())
	local c2=Duel.IsExistingMatchingCard(c20028.filter,tp,LOCATION_GRAVE,0,2,nil,e:GetHandler()) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1
	if not c1 or not c2 then return end
	local opt=2
	if c1 then opt=0 end
	if c2 then opt=1 end
	if c1 and c2 then opt=Duel.SelectOption(tp,aux.Stringid(20028,1),aux.Stringid(20028,2)) end
	if opt==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c20028.filter,tp,LOCATION_DECK,0,1,1,nil,c)
		local tc=g:GetFirst()
		if tc then
			Duel.Equip(tp,tc,c,true)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c20028.filter,tp,LOCATION_GRAVE,0,2,2,nil,c)
		local tc=g:GetFirst()
		while tc do
			Duel.Equip(tp,tc,c,true,true)
			tc=g:GetNext()
		end
		Duel.EquipComplete()
	end
end
