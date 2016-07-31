 
--月兔兵团
function c21028.initial_effect(c)
    --direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c21028.dircon)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21028,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(c21028.spcon)
	e2:SetTarget(c21028.sptg)
	e2:SetOperation(c21028.spop)
	c:RegisterEffect(e2)
end

c21028.DescSetName=0x258

function c21028.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0x256) or c:IsSetCard(0x258))
end
function c21028.dircon(e)
	return Duel.IsExistingMatchingCard(c21028.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c21028.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return c:IsRelateToBattle() and ((a==c and d:IsType(TYPE_MONSTER))
		or (d==c and a:IsType(TYPE_MONSTER)))
end
function c21028.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and (c:IsSetCard(0x256) or c:IsSetCard(0x258))	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21028.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c21028.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c21028.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21028.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end