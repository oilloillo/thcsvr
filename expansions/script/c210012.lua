--✿龙石✿
function c210012.initial_effect(c)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(210012,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,210012)
	e2:SetCost(c210012.cost)
	e2:SetTarget(c210012.target)
	e2:SetOperation(c210012.operation)
	c:RegisterEffect(e2)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(210012,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,2100120)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c210012.tgtg)
	e2:SetOperation(c210012.tgop)
	c:RegisterEffect(e2)
end
function c210012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
end
function c210012.filter(c,e,tp)
	return c:IsSetCard(0x710) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c210012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c210012.filter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c210012.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c210012.filter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,e:GetHandler(),e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c210012.filter2(c)
	return c:IsCode(210011) and c:IsAbleToHand()
end
function c210012.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210012.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_GRAVE)
end
function c210012.tgop(e,tp,eg,ep,ev,re,r,rp)
--	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c210012.filter2,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		--[[
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)]]
	end
end
