--烧芋「甜美的番薯房」
function c999306.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(999306,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCost(c999306.cost)
	e1:SetTarget(c999306.tg)
	e1:SetOperation(c999306.op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetDescription(aux.Stringid(999306,1))	
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,999306)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)	
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER+CATEGORY_TODECK)
	e2:SetCost(c999306.cost2)
	e2:SetTarget(c999306.tg2)
	e2:SetOperation(c999306.op2)
	c:RegisterEffect(e2)
end

c999306.DescSetName=0xa2

function c999306.filter(c)
	return c:IsRace(RACE_PLANT) and c:IsFaceup()
end

function c999306.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) 
		and Duel.IsExistingMatchingCard(c999306.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.PayLPCost(tp,800)
end

function c999306.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,999300,0,0x4011,0,0,2,RACE_PLANT,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end

function c999306.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,999300,0x208,0x4011,0,0,2,RACE_PLANT,ATTRIBUTE_EARTH) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,999300)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
		--
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c999306.splimit)
		e1:SetLabelObject(e)
		Duel.RegisterEffect(e1,tp)
	end
end

function c999306.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return (not c:IsLocation(LOCATION_EXTRA)) and (not c:IsRace(RACE_PLANT))
end

function c999306.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,999300) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,nil,999300)
	Duel.Release(g,REASON_COST)
end

function c999306.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1200)
end

function c999306.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Recover(tp,1200,REASON_EFFECT)
	Duel.BreakEffect()
end