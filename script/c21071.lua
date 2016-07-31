 
--因幡的欺诈师 帝
function c21071.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21071,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c21071.target)
	e1:SetOperation(c21071.operation)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(c21071.atkcon)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c21071.atkcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c21071.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c21071.spfilter(c,e,tp)
	return c:IsSetCard(0x256) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21071.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	if Duel.SelectYesNo(1-tp,aux.Stringid(21071,1)) then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsSetCard(0x161) or tc:IsSetCard(0x256) or tc:IsSetCard(0x257) then
			if Duel.IsExistingMatchingCard(c21071.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local dg=Duel.SelectMatchingCard(tp,c21071.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
				Duel.SpecialSummon(dg,0,tp,tp,false,false,POS_FACEUP)
			end
		else
			Duel.Destroy(tc,REASON_EFFECT)
		end
	Duel.ShuffleHand(tp)
	end
end
function c21071.atkcon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(Card.IsFaceup,c:GetControler(),LOCATION_MZONE,0,1,c)
end
