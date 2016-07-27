--禁忌『四重存在』
function c999404.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetDescription(aux.Stringid(999404,1))
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999404,0))
	e2:SetCategory(CATEGORY_SPSUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(4, 999404+EFFECT_COUNT_CODE_DUEL)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c999404.condition)
	e2:SetCost(c999404.cost)
	e2:SetTarget(c999404.target)
	e2:SetOperation(c999404.activate)
	c:RegisterEffect(e2)
	--Activate and use effect
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetDescription(aux.Stringid(999404,2))
	c:RegisterEffect(e3)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(c999404.tokencost)
	e4:SetTarget(c999404.tg)
	e4:SetOperation(c999404.op)
	c:RegisterEffect(e4)
end

c999404.DescSetName = 0xa3 

function c999404.cffilter(c)
	return c:IsSetCard(0x813) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end

function c999404.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999404.cffilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c999404.cffilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end

function c999404.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and not e:GetHandler():IsStatus(STATUS_CHAINING)
end

function c999404.spfilter(c,e,tp)
	return c:IsSetCard(0x815) and c:IsType(TYPE_MONSTER) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c999404.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingMatchingCard(c999404.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

function c999404.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c999404.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()==0 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)

	local tc=g:GetFirst()
	if not tc:IsOnField() then return end
	Duel.ChangeAttackTarget(tc)
end

function c999404.costfilter(c)
	return c:IsCode(999404) and c:IsAbleToRemoveAsCost()
end

function c999404.tokencost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c999404.costfilter, tp, LOCATION_GRAVE, 0, nil)
	local rep = Duel.GetFlagEffect(tp, 999410)
	local num = 3 - rep
	if num < 1 then num = 1 end
	if chk==0 then return g:GetCount()>=num end
	local rg=g:RandomSelect(tp,num)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.ResetFlagEffect(tp, 999410)
end

function c999404.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>3
		and Duel.IsPlayerCanSpecialSummonMonster(tp,999409,0,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,4,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,4,0,0)
end

function c999404.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>3 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,999409,0,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) then
		for i=1,4 do
			local token=Duel.CreateToken(tp,999409)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
		end
		Duel.SpecialSummonComplete()
		if _G["c999409"] then
			_G["c999409"].DescSetName = 0xa3
		end
	end
end