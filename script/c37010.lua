--决战符『怪雨奇迹』
function c37010.initial_effect(c)
	--turnset
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_CANNOT_TURN_SET)
	e0:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c37010.condition)
	e1:SetTarget(c37010.target)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(37010,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c37010.drtg)
	e2:SetOperation(c37010.drop)
	c:RegisterEffect(e2)

	if c37010.counter == nil then
		c37010.counter = true
		Uds.regUdsEffect(e1,37010)
	end
end
function c37010.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLocation()~=LOCATION_HAND and e:GetHandler():GetPreviousLocation()~=LOCATION_HAND and not re:GetHandler():IsCode(37000)
end
function c37010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler() and e:GetHandler():IsOnField() then 
		Duel.SetChainLimit(c37010.chainlimit)
	end
end
function c37010.chainlimit(e,rp,tp)
	return e:GetHandler():IsSetCard(0x214)
end
function c37010.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c37010.filter1(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsSetCard(0x208) and c:IsAbleToGrave()
end
function c37010.filter2(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsSetCard(0x208) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c37010.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	if tc:IsAttribute(ATTRIBUTE_WIND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local dg=Duel.SelectMatchingCard(tp,c37010.filter1,tp,LOCATION_DECK,0,1,1,nil)
		if dg:GetCount()>0 then
			Duel.SendtoGrave(dg,REASON_EFFECT)
		end
	elseif tc:IsAttribute(ATTRIBUTE_WATER) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local dg=Duel.SelectMatchingCard(tp,c37010.filter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if dg:GetCount()>0 then
			Duel.SpecialSummon(dg,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
	Duel.ShuffleHand(tp)
end
